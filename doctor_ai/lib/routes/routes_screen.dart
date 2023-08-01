import 'package:doctor_ai/screens/authentication/signup_screen.dart';
import 'package:doctor_ai/screens/chatting/chatting_screen.dart';
import 'package:doctor_ai/screens/doctor_profile.dart';
import 'package:doctor_ai/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes = {
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/doctors-chatting': (context) => const ChattingScreen(),
    '/notification': (context) => const ProfileScreen(),
    '/doctor-profile': (context) => const DoctorProfile(),
    '/signup': (context) => const SignupScreen(),
  };
}
