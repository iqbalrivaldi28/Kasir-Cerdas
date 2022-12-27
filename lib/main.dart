import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/routes.dart';
import 'package:kasir_cerdas/constant/shapes.dart';

import 'package:kasir_cerdas/page/wrapper.dart';
import 'package:kasir_cerdas/provider/auth.dart';
import 'package:kasir_cerdas/provider/operator_provider.dart';
import 'package:kasir_cerdas/provider/total_payment.dart';
import 'package:provider/provider.dart';

import 'services/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Session.init();
  runApp(const KasirCerdas());
}

class KasirCerdas extends StatelessWidget {
  const KasirCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<OperatorProvider>(create: (context) => OperatorProvider()),
        ChangeNotifierProvider<TotalPaymentProvider>(create: (context) => TotalPaymentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Wrapper.route,
        routes: routes,
        theme: ThemeData(
          fontFamily: 'Inter',
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: mbRadius),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
          ),
        ),
      ),
    );
  }
}
