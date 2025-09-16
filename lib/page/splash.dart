import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medical_app/auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    _navigateToNextScreen();
  }

  static Future<Map<String, bool>> checkAllPermissions() async {
    final results = <String, bool>{};
    
    results['notification'] = await Permission.notification.status.isGranted;
    results['storage'] = await Permission.storage.status.isGranted;
    results['location'] = await Permission.location.status.isGranted;
    
    return results;
  }

  static Future<Map<String, bool>> _requestAllPermissions() async {
    final results = <String, bool>{};
    final currentPermissions = await checkAllPermissions();
    if (!currentPermissions['notification']!) {
      results['notification'] = await requestPermission(Permission.notification);
    } else {
      results['notification'] = true;
    }
    
    if (!currentPermissions['storage']!) {
      results['storage'] = await requestPermission(Permission.storage);
    } else {
      results['storage'] = true;
    }
    
    if (!currentPermissions['location']!) {
      results['location'] = await requestPermission(Permission.location);
    } else {
      results['location'] = true;
    }
    
    return results;
  }

  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      final permissionStatus = await checkAllPermissions();
      print('Status perizinan sebelum meminta: $permissionStatus');
      await _requestAllPermissions();
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: const Color(0xFF199A8E),
                    highlightColor: Colors.white,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: const Color(0xFF199A8E),
                    highlightColor: Colors.white,
                    child: const Text(
                      'GlucoWise',
                      style: TextStyle(
                        fontFamily: 'DarumadropOne',
                        color: Color(0xFF199A8E),
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return SizedBox(
                        width: 150,
                        height: 5,
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF199A8E)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
