import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/page/dashboard.dart';
import 'package:medical_app/page/profile.dart';
import 'package:medical_app/page/gluco_care.dart';
import 'package:medical_app/page/gluco_screening.dart';
import 'package:medical_app/page/gluco_check.dart';

class NavBottom extends StatelessWidget {
  const NavBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      color: const Color(0xFFF9FAFB),
      selectedIconColor: const Color(0xFF199A8E),
      unselectedIconColor: const Color(0xFF199A8E).withOpacity(0.6),
      borderRadius: 30,
      horizontalPadding: 20,
      hapticFeedback: true,
      items: [
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.house,
          title: "Dashboard",
          page: const DashboardScreen(),
        ),
        FloatingNavBarItem(
          // ignore: deprecated_member_use
          iconData: FontAwesomeIcons.heartbeat,
          title: "Screening",
          page: const GlucoScreeningScreen(),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.kitMedical,
          title: "GlucoCheck",
          page: GlucoCheckScreen(),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.pills,
          title: "GlucoCare",
          page: const GlucoCareScreen(),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.user,
          title: "User",
          page: const UserScreen(),
        ),
      ],
    );
  }
}