import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/page/splash.dart';
import 'package:medical_app/services/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Diabetic Management',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}