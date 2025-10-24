import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:eshop/Helper/Color.dart';
import 'package:eshop/Helper/Constant.dart';
import 'package:eshop/Helper/PushNotificationService.dart';
import 'package:eshop/Helper/Session.dart';
import 'package:eshop/Helper/SqliteData.dart';
import 'package:eshop/Helper/String.dart';
import 'package:eshop/Helper/routes.dart';
import 'package:eshop/Model/Section_Model.dart';
import 'package:eshop/Model/message.dart';
import 'package:eshop/Provider/HomeProvider.dart';
import 'package:eshop/Provider/UserProvider.dart';
import 'package:eshop/Screen/FlashSale.dart';
import 'package:eshop/Screen/Profile/MyProfile.dart';
import 'package:eshop/Screen/cart/Cart.dart';
import 'package:eshop/cubits/personalConverstationsCubit.dart';
import 'package:eshop/repository/notificationRepository.dart';
import 'package:eshop/utils/blured_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Provider/SettingProvider.dart';
import '../app/routes.dart';
import '../cubits/fetch_featured_sections_cubit.dart';
import '../ui/styles/DesignConfig.dart';
import 'All_Category.dart';
import 'HomePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static GlobalKey<HomePageStates> dashboardScreenKey =
      GlobalKey<HomePageStates>();
  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return Dashboard(
          key: dashboardScreenKey,
        );
      },
    );
  }

  @override
  HomePageStates createState() => HomePageStates();
}

class HomePageStates extends State<Dashboard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selBottom = 0;
  final PageController _pageController = PageController();
  bool _isNetworkAvail = true;
  DatabaseHelper db = DatabaseHelper();
  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late AppLinks _appLinks;
  late StreamSubscription<Uri>? _linkSubscription;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAppLinks();
    Future.delayed(Duration.zero, () {
      // final pushNotificationService = PushNotificationService(context: context);
      // pushNotificationService.initialise();
    });
    NotificationRepository.clearChatNotifications();
    db.getTotalCartCount(context);
    Future.delayed(Duration.zero, () async {
      final SettingProvider settingsProvider =
          Provider.of<SettingProvider>(context, listen: false);
      context
          .read<UserProvider>()
          .setUserId(await settingsProvider.getPrefrence(ID) ?? '');
      context
          .read<HomeProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    });
  }

  Future<void> handleDeepLink(Uri uri) async {
    if (uri.path.contains('/products/details/')) {
      final String slug = uri.pathSegments.last;
      print("productslug--->$slug");
      if (slug.isNotEmpty) {
        final product = await getProductDetailsFromSlug(slug);
        if (product != null) {
          Routes.goToProductDetailsPage(context, product: product);
        }
      }
    } else {
      if (kDebugMode) {
        print('Received deep link: $uri');
      }
    }
  }

  Future<Product?> getProductDetailsFromSlug(String slug) async {
    try {
      final getData = await apiBaseHelper.postAPICall(getProductApi, {
        SLUG: slug,
        USER_ID: context.read<UserProvider>().userId,
      });
      print("productdetailslug--->$slug-->$getData");
      final bool error = getData['error'];
      if (!error) {
        final data = getData['data'];
        final List<Product> tempList =
            (data as List).map((data) => Product.fromJson(data)).toList();
        if (tempList.isEmpty) {
          setSnackbar(
            getTranslated(context, 'NO_PRODUCTS_WITH_YOUR_LINK_FOUND')!,
            context,
          );
          return null;
        }
        return tempList[0] as Product?;
      } else {
        throw Exception();
      }
    } catch (_) {}
    return null;
  }

  changeTabPosition(int index) {
    Future.delayed(Duration.zero, () {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      NotificationRepository.getChatNotifications().then((messages) {
        for (final encodedMessage in messages) {
          final message =
              Message.fromJson(Map.from(jsonDecode(encodedMessage) ?? {}));
          if (converstationScreenStateKey.currentState?.mounted ?? false) {
            final state = converstationScreenStateKey.currentState!;
            if (state.widget.isGroup) {
            } else {
              if (state.widget.personalChatHistory?.getOtherUserId() !=
                  message.fromId) {
                context
                    .read<PersonalConverstationsCubit>()
                    .updateUnreadMessageCounter(userId: message.fromId!);
              } else {
                state.addMessage(message: message);
              }
            }
          } else {
            if (message.type == 'person') {
              context
                  .read<PersonalConverstationsCubit>()
                  .updateUnreadMessageCounter(
                    userId: message.fromId!,
                  );
            } else {}
          }
        }
        NotificationRepository.clearChatNotifications();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selBottom == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selBottom != 0) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      child: SafeArea(
        top: false,
        child: Consumer<UserProvider>(
          builder: (context, data, child) {
            return Scaffold(
              extendBody: true,
              backgroundColor: Theme.of(context).colorScheme.lightWhite,
              appBar: _getAppBar(),
              body: PageView(
                controller: _pageController,
                children: const [
                  HomePage(),
                  AllCategory(),
                  FlashSale(),
                  Cart(
                    fromBottom: true,
                  ),
                  MyProfile(),
                ],
                onPageChanged: (index) {
                  setState(() {
                    if (!context
                        .read<HomeProvider>()
                        .animationController
                        .isAnimating) {
                      context
                          .read<HomeProvider>()
                          .animationController
                          .reverse();
                      context.read<HomeProvider>().showBars(value: true);
                    }
                    _selBottom = index;
                    if (index == 3) {
                      cartTotalClear();
                    }
                  });
                },
              ),
              bottomNavigationBar: _getBottomBar(),
            );
          },
        ),
      ),
    );
  }

  Future<void> getProduct(String id, int index, int secPos,
      {required bool list}) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        final parameter = {
          ID: id,
        };
        apiBaseHelper.postAPICall(getProductApi, parameter).then(
          (getdata) {
            final bool error = getdata["error"];
            final String msg = getdata["message"];
            if (!error) {
              final data = getdata["data"];
              List<Product> items = [];
              final List<SectionModel> featuredSections = context
                  .watch<FetchFeaturedSectionsCubit>()
                  .getFeaturedSections();
              items =
                  (data as List).map((data) => Product.fromJson(data)).toList();
              currentHero = homeHero;
              Navigator.pushNamed(
                context,
                Routers.productDetails,
                arguments: {
                  "index": list ? int.parse(id) : index,
                  "id": list
                      ? items[0].id!
                      : featuredSections[secPos].productList![index].id!,
                  "secPos": secPos,
                  "list": list,
                },
              );
            } else {
              if (msg != "Products Not Found !") setSnackbar(msg, context);
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      {
        if (mounted) {
          setState(() {
            setSnackbar(getTranslated(context, 'NO_INTERNET_DISC')!, context);
          });
        }
      }
    }
  }

  AppBar _getAppBar() {
    String? title;
    if (_selBottom == 1) {
      title = getTranslated(context, 'CATEGORY');
    } else if (_selBottom == 2) {
      title = getTranslated(context, 'OFFER');
    } else if (_selBottom == 3) {
      title = getTranslated(context, 'MYBAG');
    } else if (_selBottom == 4) {
      title = getTranslated(context, 'PROFILE');
    }
    return AppBar(
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: _selBottom == 0
          ? SvgPicture.asset(
              'assets/images/titleicon.svg',
              height: 35,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primarytheme,
                BlendMode.srcIn,
              ),
            )
          : Text(
              title!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primarytheme,
                fontWeight: FontWeight.normal,
              ),
            ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "${imagePath}desel_notification.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.blackInverseInDarkTheme,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            final userProvider = context.read<UserProvider>();
            if (userProvider.userId != "") {
              Navigator.pushNamed(
                context,
                Routers.notificationListScreen,
              ).then((value) {
                if (value != null && value == true) {
                  _pageController.jumpToPage(1);
                }
              });
            } else {
              Navigator.pushNamed(
                context,
                Routers.loginScreen,
                arguments: {
                  "isPop": true,
                  "classType": Dashboard(
                    key: Dashboard.dashboardScreenKey,
                  ),
                },
              );
            }
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            "${imagePath}desel_fav.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.blackInverseInDarkTheme,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routers.favoriteScreen,
            );
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
    );
  }

  Widget _getBottomBar() {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: navigationContainerAnimationController,
          curve: Curves.easeInOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0))
            .animate(
          CurvedAnimation(
            parent: navigationContainerAnimationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomBar(
            height: 60,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            selectedIndex: _selBottom,
            onTap: (int index) {
              _pageController.jumpToPage(index);
              setState(() => _selBottom = index);
            },
            items: <BottomBarItem>[
              BottomBarItem(
                icon: _selBottom == 0
                    ? SvgPicture.asset(
                        "${imagePath}sel_home.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 20,
                      )
                    : SvgPicture.asset(
                        "${imagePath}desel_home.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 20,
                      ),
                title: Text(
                  getTranslated(
                    context,
                    'HOME_LBL',
                  )!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                activeColor: Theme.of(context).colorScheme.primarytheme,
              ),
              BottomBarItem(
                icon: _selBottom == 1
                    ? SvgPicture.asset(
                        "${imagePath}category01.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 18,
                      )
                    : SvgPicture.asset(
                        "${imagePath}category.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 18,
                      ),
                title: Text(
                  getTranslated(context, 'category')!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                activeColor: Theme.of(context).colorScheme.primarytheme,
              ),
              BottomBarItem(
                icon: _selBottom == 2
                    ? SvgPicture.asset(
                        "${imagePath}sale02.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 20,
                      )
                    : SvgPicture.asset(
                        "${imagePath}sale.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 20,
                      ),
                title: Text(
                  getTranslated(context, 'SALE')!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                activeColor: Theme.of(context).colorScheme.primarytheme,
              ),
              BottomBarItem(
                icon: Selector<UserProvider, String>(
                  builder: (context, data, child) {
                    return Stack(
                      children: [
                        if (_selBottom == 3)
                          SvgPicture.asset(
                            "${imagePath}cart01.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primarytheme,
                              BlendMode.srcIn,
                            ),
                            width: 18,
                            height: 20,
                          )
                        else
                          SvgPicture.asset(
                            "${imagePath}cart.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primarytheme,
                              BlendMode.srcIn,
                            ),
                            width: 18,
                            height: 20,
                          ),
                        if (data.isNotEmpty && data != "0")
                          Positioned.directional(
                            end: 0,
                            textDirection: Directionality.of(context),
                            top: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).colorScheme.primarytheme,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    data,
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    );
                  },
                  selector: (_, homeProvider) => homeProvider.curCartCount,
                ),
                title: Text(
                  getTranslated(context, 'CART')!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                activeColor: Theme.of(context).colorScheme.primarytheme,
              ),
              BottomBarItem(
                icon: _selBottom == 4
                    ? SvgPicture.asset(
                        "${imagePath}profile01.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 20,
                      )
                    : SvgPicture.asset(
                        "${imagePath}profile.svg",
                        width: 18,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primarytheme,
                          BlendMode.srcIn,
                        ),
                      ),
                title: Text(
                  getTranslated(context, 'PROFILE')!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                activeColor: Theme.of(context).colorScheme.primarytheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
