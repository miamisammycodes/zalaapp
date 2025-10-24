import 'package:eshop/Helper/Constant.dart';
import 'package:eshop/Model/Section_Model.dart';
import 'package:eshop/Model/groupDetails.dart';
import 'package:eshop/Model/personalChatHistory.dart';
import 'package:eshop/Screen/Product_DetailNew.dart';
import 'package:eshop/Screen/chat/converstationListScreen.dart';
import 'package:eshop/Screen/chat/converstationScreen.dart';
import 'package:eshop/Screen/chat/searchAdminScreen.dart';
import 'package:eshop/cubits/converstationCubit.dart';
import 'package:eshop/cubits/searchAdminCubit.dart';
import 'package:eshop/cubits/sendMessageCubit.dart';
import 'package:eshop/repository/adminDetailsRepository.dart';
import 'package:eshop/repository/chatRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: avoid_classes_with_only_static_members
class Routes {
  static navigateToConverstationListScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ConverstationListScreen(
          key: converstationListScreenStateKey,
        ),
      ),
    );
  }

  static navigateToConverstationScreen({
    required BuildContext context,
    PersonalChatHistory? personalChatHistory,
    GroupDetails? groupDetails,
    required bool isGroup,
  }) {
    converstationScreenStateKey = GlobalKey<ConverstationScreenState>();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ConverstationCubit(ChatRepository()),
            ),
            BlocProvider(
              create: (_) => SendMessageCubit(ChatRepository()),
            ),
          ],
          child: ConverstationScreen(
            groupDetails: groupDetails,
            key: converstationScreenStateKey,
            isGroup: isGroup,
            personalChatHistory: personalChatHistory,
          ),
        ),
      ),
    );
  }

  static navigateToSearchSellerScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SearchAdminCubit(AdminDetailRepository()),
          child: const SearchAdminScreen(),
        ),
      ),
    );
  }

  static Future<void> goToProductDetailsPage(
    BuildContext context, {
    required Product product,
  }) async {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProductDetail(
          id: product.id!,
          list: false,
          index: 0,
          secPos: 0,
        ),
      ),
    );
  }

  static navigateToGroupInfoScreen(
    BuildContext context,
    GroupDetails groupDetails,
  ) {}
}
