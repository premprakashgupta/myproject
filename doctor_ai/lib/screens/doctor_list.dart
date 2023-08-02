import 'package:doctor_ai/providers/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_ai/models/doctors_model.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor List'),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, _) {
          // Access the doctorsList from the provider
          List<DoctorsModel> doctorsList = provider.doctorsList;

          if (doctorsList.isEmpty) {
            // Show a message if the list is empty
            return const Center(child: Text('No doctors found.'));
          }

          return ListView.builder(
            itemCount: doctorsList.length,
            itemBuilder: (context, index) {
              DoctorsModel doctorData = doctorsList[index];
              print("doctor list $doctorData");
              return _buildDoctorCard(doctorData, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(DoctorsModel doctor, context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 30.0,
            //   backgroundImage: NetworkImage(doctor.avatarUrl),
            // ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/doctor-profile',
                          arguments: doctor.ref.id);
                    },
                    child: Text(
                      doctor.ref.username,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    doctor.hospitalName,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    doctor.degree,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Experience: ${doctor.experience}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/doctors-chatting",
                        arguments: {
                          'receiverId': doctor.ref.id,
                          'receiverName': doctor.ref.username
                        });
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('chatting'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement video call functionality
                  },
                  icon: const Icon(Icons.video_call),
                  label: const Text('video call'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement video call functionality
                  },
                  icon: const Icon(Icons.note_alt_outlined),
                  label: const Text('Book appointement'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
