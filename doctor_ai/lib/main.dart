import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:doctor_ai/firebase_options.dart';
import 'package:doctor_ai/providers/doctor_provider.dart';
import 'package:doctor_ai/providers/user_provider.dart';
import 'package:doctor_ai/routes/routes_screen.dart';
import 'package:doctor_ai/providers/chatting_provider.dart';

import 'package:doctor_ai/screens/landing_screen.dart';
import 'package:doctor_ai/screens/authentication/signin_screen.dart';
import 'package:doctor_ai/utility/mynotification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final MyNotification myNotification = MyNotification();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  myNotification.initNotification();
  // var status = await Permission.storage.request();
  // if (!status.isGranted) {
  //   // Handle the case when permission is denied
  //   // You can show a message to the user or handle it in some other way
  //   return;
  // }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..userDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorProvider()..fetchDoctorList(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChattingProvider(),
        ),
      ],
      child: MyApp(),
    ),

    // MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // generate callerID of local user
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  @override
  Widget build(BuildContext context) {
    // SignallingService.instance.init(
    //   websocketUrl:
    //       'http://localhost:5000', // Replace with your actual WebSocket server URL
    //   selfCallerID:
    //       selfCallerID, // Replace with the unique identifier of the current user or caller
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: StoreMsgLocally(),
      initialRoute: "/",
      routes: Routes.routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return const SigninScreen();
            } else {
              // Update the UserProvider with the user data
              // final userProvider =
              //     Provider.of<UserProvider>(context, listen: false);
              // var res = userProvider.userDataProvider();

              // if (res != null) {
              return const LandingScreen();
              // } else {
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
              // }
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
