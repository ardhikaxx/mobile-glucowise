import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/page/dashboard.dart';
import 'package:medical_app/page/UserProfile/profile.dart';
import 'package:medical_app/page/GlucoCare/gluco_care.dart';
import 'package:medical_app/page/Screening/gluco_screening.dart';
import 'package:medical_app/page/GlucoCheck/gluco_check.dart';
import 'package:medical_app/model/user.dart';

class NavBottom extends StatelessWidget {
  final UserData userData;

  const NavBottom({super.key, required this.userData});

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
          page: DashboardScreen(userData: userData),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.heartbeat,
          title: "Screening",
          page: GlucoScreeningScreen(userData: userData),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.kitMedical,
          title: "GlucoCheck",
          page: GlucoCheckScreen(userData: userData),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.pills,
          title: "GlucoCare",
          page: GlucoCareScreen(userData: userData),
        ),
        FloatingNavBarItem(
          iconData: FontAwesomeIcons.user,
          title: "User",
          page: UserScreen(userData: userData),
        ),
      ],
    );
  }
}