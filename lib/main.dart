import 'dart:io';
import 'package:eshop/Helper/Color.dart';
import 'package:eshop/Helper/Constant.dart';
import 'package:eshop/Provider/CartProvider.dart';
import 'package:eshop/Provider/CategoryProvider.dart';
import 'package:eshop/Provider/FavoriteProvider.dart';
import 'package:eshop/Provider/FlashSaleProvider.dart';
import 'package:eshop/Provider/HomeProvider.dart';
import 'package:eshop/Provider/OfferImagesProvider.dart';
import 'package:eshop/Provider/ProductDetailProvider.dart';
import 'package:eshop/Provider/ProductProvider.dart';
import 'package:eshop/Provider/UserProvider.dart';
import 'package:eshop/Provider/pushNotificationProvider.dart';
import 'package:eshop/app/languages.dart';
import 'package:eshop/cubits/brandsListCubit.dart';
import 'package:eshop/cubits/fetch_citites.dart';
import 'package:eshop/cubits/fetch_featured_sections_cubit.dart';
import 'package:eshop/cubits/personalConverstationsCubit.dart';
import 'package:eshop/cubits/predefinedReturnReasonCubit.dart';
import 'package:eshop/repository/brandsRepository.dart';
import 'package:eshop/repository/chatRepository.dart';
import 'package:eshop/repository/predefinedReturnRepository.dart';
import 'package:eshop/ui/styles/themedata.dart';
import 'package:eshop/utils/Hive/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';
import 'Provider/MyFatoraahPaymentProvider.dart';
import 'Provider/SettingProvider.dart';
import 'Provider/Theme.dart';
import 'Provider/order_provider.dart';
import 'app/app_Localization.dart';
import 'app/routes.dart';

////App version
/// V4.4.4

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  await HiveUtils.initBoxes();
  initializedDownload();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (BuildContext context) {
            if (disableDarkTheme == false) {
              final String? theme = prefs.getString(APP_THEME);
              if (theme == DARK) {
                ISDARK = "true";
              } else if (theme == LIGHT) {
                ISDARK = "false";
              }
              if (theme == null || theme == "" || theme == DEFAULT_SYSTEM) {
                prefs.setString(APP_THEME, DEFAULT_SYSTEM);
                final brightness = SchedulerBinding
                    .instance.platformDispatcher.platformBrightness;
                ISDARK = (brightness == Brightness.dark).toString();
                return ThemeNotifier(ThemeMode.system);
              }
              return ThemeNotifier(
                theme == LIGHT ? ThemeMode.light : ThemeMode.dark,
              );
            } else {
              return ThemeNotifier(ThemeMode.light);
            }
          },
        ),
        Provider<SettingProvider>(
          create: (context) => SettingProvider(prefs),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ProductDetailProvider>(
          create: (context) => ProductDetailProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<FlashSaleProvider>(
          create: (context) => FlashSaleProvider(),
        ),
        ChangeNotifierProvider<OfferImagesProvider>(
          create: (context) => OfferImagesProvider(),
        ),
        ChangeNotifierProvider<PaymentIdProvider>(
          create: (context) => PaymentIdProvider(),
        ),
        ChangeNotifierProvider<PushNotificationProvider>(
          create: (context) => PushNotificationProvider(),
        ),
        BlocProvider<PersonalConverstationsCubit>(
          create: (context) => PersonalConverstationsCubit(ChatRepository()),
        ),
        BlocProvider<BrandsListCubit>(
          create: (context) =>
              BrandsListCubit(brandsRepository: BrandsRepository()),
        ),
        BlocProvider<PredefinedReturnReasonListCubit>(
          create: (context) => PredefinedReturnReasonListCubit(
              predefinedreturnrepository: PredefinedReturnRepository()),
        ),
        BlocProvider<FetchCitiesCubit>(create: (context) => FetchCitiesCubit()),
        BlocProvider<FetchFeaturedSectionsCubit>(
          create: (context) => FetchFeaturedSectionsCubit(),
        ),
      ],
      child: MyApp(sharedPreferences: prefs),
    ),
  );
}

Future<void> initializedDownload() async {
  await FlutterDownloader.initialize();
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  MyAppState createState() => MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    final MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted) {
        setState(() {
          _locale = locale;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  setLocale(Locale locale) {
    if (mounted) {
      setState(() {
        _locale = locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    if (_locale == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primarytheme,
          valueColor: AlwaysStoppedAnimation<Color?>(
            Theme.of(context).colorScheme.primarytheme,
          ),
        ),
      );
    } else {
      return MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: GlobalScrollBehavior(),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // Optional
                statusBarIconBrightness:
                    Brightness.dark, // Status bar icons → dark (black)
                systemNavigationBarColor: Theme.of(context)
                    .colorScheme
                    .NaviColor, // Bottom nav bar background
                systemNavigationBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
              ),
              child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.lightWhite,
                  body: SafeArea(
                    top: false,
                    child: child!,
                  )),
            ),
          ); // Directionality
        },
        locale: _locale,
        supportedLocales: [...Languages().codes()],
        onGenerateRoute: Routers.onGenerateRouted,
        initialRoute: Routers.splash,
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        navigatorKey: navigatorKey,
        title: appName,
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: themeNotifier.getThemeMode(),
      );
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Optionally customize scrollbar behavior
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Optionally customize overscroll glow behavior
    return child; // No glow effect
  }
}
