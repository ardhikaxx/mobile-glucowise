import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/page/splash.dart';
import 'package:medical_app/services/global.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GlucoWise',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}