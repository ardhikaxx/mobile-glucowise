import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/page/dashboard.dart';
import 'package:medical_app/page/user.dart';
import 'package:medical_app/page/gluconote.dart';
import 'package:medical_app/page/glucoscreening.dart';
import 'package:medical_app/page/glucocheck.dart';

class NavBottom extends StatelessWidget {
  const NavBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      color: const Color(0xFFFFD0DC),
      selectedIconColor: const Color(0xFFC63755),
      unselectedIconColor: const Color(0xFFC63755).withOpacity(0.5),
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
          iconData: FontAwesomeIcons.bookMedical,
          title: "GlucoNote",
          page: const GlucoNoteScreen(),
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
          page: const GlucoCheckScreen(),
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