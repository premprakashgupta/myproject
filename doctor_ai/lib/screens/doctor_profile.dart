import 'package:flutter/material.dart';
import 'package:doctor_ai/firebase/firestore_service.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirestoreService().doctorProfile(uid: uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error fetching data'));
          }

          final doctorData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Circular Avatar
                // CircleAvatar(
                //   radius: 50.0,
                //   // Replace 'doctorData.avatarUrl' with the actual URL of the doctor's avatar
                //   backgroundImage: NetworkImage(doctorData.avatarUrl),
                // ),

                const SizedBox(height: 16.0),
                // Username
                Text(
                  doctorData['ref']["username"],
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Degree
                Text(
                  doctorData["degree"],
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                // Specialist
                Text(
                  doctorData["specialist"],
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                // Experience
                Text(
                  'Experience: ${doctorData["experience"]} years',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                // Hospital Name
                Text(
                  doctorData["hospitalName"],
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                // Rating
                Text(
                  'Rating: ${doctorData["rating"]}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Tags
                Wrap(
                  spacing: 8.0,
                  children: doctorData["tags"].map<Widget>((tag) {
                    return Chip(label: Text(tag as String));
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                // Button for book appointment
                ElevatedButton(
                  onPressed: () {
                    // Implement the booking functionality here
                  },
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
