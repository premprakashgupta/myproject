import 'package:doctor_ai/screens/chatting/chatting_user_list.dart';
import 'package:doctor_ai/screens/home_screen.dart';
import 'package:doctor_ai/screens/notification_screen.dart';
import 'package:doctor_ai/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    final List<Widget> screens = [
      const HomeScreen(),
      // user!.role == 'doctor'
      //     ? const ChattingUserLists()
      //     : const DoctorListScreen(),
      const ChattingUserLists(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState currentNavigator =
            _navigatorKeys[_currentIndex].currentState!;
        if (currentNavigator.canPop()) {
          currentNavigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(255, 200, 236, 158),
          unselectedItemColor: const Color.fromARGB(255, 149, 202, 226),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: HeroIcon(
                HeroIcons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: HeroIcon(
                HeroIcons.userGroup,
              ),
              label: 'Connect',
            ),
            BottomNavigationBarItem(
              icon: HeroIcon(
                HeroIcons.buildingOffice2,
              ),
              label: 'Labs',
            ),
            BottomNavigationBarItem(
              icon: HeroIcon(
                HeroIcons.user,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
