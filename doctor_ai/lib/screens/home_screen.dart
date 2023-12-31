import 'package:doctor_ai/providers/user_provider.dart';
import 'package:doctor_ai/screens/bot/bot_chatting_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 200, 236, 158),
        actions: [
          IconButton(
            onPressed: () {
              // Handle news icon pressed
            },
            icon: const HeroIcon(
              HeroIcons.bell,
              style:
                  HeroIconStyle.outline, // Outlined icons are used by default.
              color: Colors.black,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle settings icon pressed
            },
            icon: const HeroIcon(
              HeroIcons.cog6Tooth,
              style:
                  HeroIconStyle.outline, // Outlined icons are used by default.
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.8, 1.0],
            colors: [
              Color.fromARGB(255, 200, 236, 158), // Top left light green
              Colors.white, // Center white
              Color.fromARGB(255, 149, 202, 226), // Bottom right light blue
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1636955992879-c3c4d4cc2f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHZlY3RvcnxlbnwwfDB8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(width: 30),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${Provider.of<UserProvider>(context).user?.username ?? ''}, I'm Dr. AI. I can help you learn more about your health",
                        style: GoogleFonts.lora(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BotChattingScreen(),
                            ),
                          );
                        },
                        child: const Text("Start Symptom Assessment"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              "Feature",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: Card(
                child: Column(
                  children: [
                    Image.network(
                        height: 100,
                        'https://images.unsplash.com/photo-1636955992879-c3c4d4cc2f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHZlY3RvcnxlbnwwfDB8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60'),
                    const ListTile(
                      title: Text("Feature Title 1"),
                      subtitle: Text("Feature Subtitle 1"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Other Facility",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              // width: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      width: 300,
                      height: 80,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
