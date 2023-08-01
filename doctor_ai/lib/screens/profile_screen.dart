import 'package:doctor_ai/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularAvatar(
              imageUrl: '', // Use user's photoURL if available
              radius: 60.0,
            ),
            const SizedBox(height: 20.0),
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              final user = userProvider.user;
              print("profile ------------------$user");
              if (user == null) {
                // Fetch and set user data if not available
                userProvider.userDataProvider();
                return const CircularProgressIndicator();
              } else {
                return Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }),
            const SizedBox(height: 8.0),
            const Text(
              'No Email',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class CircularAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const CircularAvatar({
    required this.imageUrl,
    this.radius = 40.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person,
              size: radius * 2.0,
              color: Colors.grey,
            )
          : null,
    );
  }
}
