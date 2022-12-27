import 'package:flutter/material.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/page/add_goods_page.dart';
import 'package:kasir_cerdas/page/change_password_page.dart';
import 'package:kasir_cerdas/page/edit_goods_page.dart';
import 'package:kasir_cerdas/page/edit_profile_page.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/page/on_boarding.dart';
import 'package:kasir_cerdas/page/otp_page.dart';
import 'package:kasir_cerdas/page/pay_page.dart';
import 'package:kasir_cerdas/page/profile_page.dart';
import 'package:kasir_cerdas/page/receipt_preview_page.dart';

import 'package:kasir_cerdas/page/scanner_page.dart';
import 'package:kasir_cerdas/page/shop_register_page.dart';
import 'package:kasir_cerdas/page/signin_page.dart';
import 'package:kasir_cerdas/page/signup_page.dart';
import 'package:kasir_cerdas/page/total_pay_page.dart';
import 'package:kasir_cerdas/page/transaction_page.dart';
import 'package:kasir_cerdas/page/transaction_succes_page.dart';
import 'package:kasir_cerdas/page/wrapper.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.route: (context) => const Wrapper(),
  OnBoardingPage.route: (context) => const OnBoardingPage(),
  SignupPage.route: (context) => const SignupPage(),
  SigninPage.route: (context) => const SigninPage(),
  OtpPage.route: (context) => const OtpPage(),
  ChangePasswordPage.route: (context) => const ChangePasswordPage(),
  ShopRegisterPage.route: (context) => const ShopRegisterPage(),
  MainPage.route: (context) => const MainPage(),
  AddGoodsPage.route: (context) {
    String code = ModalRoute.of(context)!.settings.arguments as String;
    return AddGoodsPage(code: code);
  },
  TransactionPage.route: (context) => const TransactionPage(),
  TotalPayPage.route: (context) => const TotalPayPage(),
  PayPage.route: (context) => const PayPage(),
  TransactionSuccesPage.route: (context) => const TransactionSuccesPage(),
  ReceiptPreviewPage.route: (context) => const ReceiptPreviewPage(),
  ProfilePage.route: (context) => const ProfilePage(),
  EditProfilePage.route: (context) => const EditProfilePage(),
  ScannerPage.route: (context) {
    final onScan =
        ModalRoute.of(context)!.settings.arguments as Function(String)?;
    return ScannerPage(
      onScanned: onScan,
    );
  },
  EditGoodsPage.route: (context) {
    final goods = ModalRoute.of(context)!.settings.arguments as Goods;
    return EditGoodsPage(
      goods: goods,
    );
  },
};
