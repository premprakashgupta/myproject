import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:flutter/material.dart';

class ChattingUserLists extends StatelessWidget {
  const ChattingUserLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting User List'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreService()
            .fetchChattingUserList(), // Use the stream from the function
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Data is available
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildUserTile(context, snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            // Handle error if necessary
            return const Center(
              child: Text('Error fetching data'),
            );
          } else {
            // Data is still loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, receiver) {
    return ListTile(
      // leading: CircleAvatar(
      //   // Replace the avatarUrl with the actual URL of the user's avatar
      //   backgroundImage:
      //       NetworkImage(user['avatarUrl']), // Access the fields correctly
      // ),
      title:
          Text(receiver['receiver']["username"]), // Access the fields correctly
      subtitle: Text(receiver['chats'][0]['message']
          ['content']), // Access the fields correctly
      // trailing: Text(receiver['time']), // Access the fields correctly
      onTap: () {
        Navigator.pushNamed(context, "/doctors-chatting", arguments: {
          'receiverId': receiver['receiver']["id"],
          'receiverName': receiver['receiver']["username"]
        });
      },
    );
  }
}
