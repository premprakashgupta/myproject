import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_ai/providers/chatting_provider.dart';

class ChattingUserLists extends StatefulWidget {
  const ChattingUserLists({super.key});

  @override
  State<ChattingUserLists> createState() => _ChattingUserListsState();
}

class _ChattingUserListsState extends State<ChattingUserLists> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Provider.of<ChattingProvider>(context, listen: false).clearChatMessages();
    // Fetch chats here instead of in initState
    Provider.of<ChattingProvider>(context, listen: false).fetchChatsPF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting User List'),
      ),
      body: Consumer<ChattingProvider>(
        builder: (context, chattingProvider, _) {
          final chatMessages = chattingProvider.chatMessages;

          if (chatMessages.isEmpty) {
            // Data is still loading or empty
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              return _buildUserTile(context, chatMessages[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, Map<String, dynamic> profile) {
    print("profile----------$profile");
    // return CircularProgressIndicator();
    final profileData = profile['profileData'] as Map<String, dynamic>;
    final chats = profile['chats'] as List<dynamic>;

    final lastChat = chats.isNotEmpty ? chats.last : null;
    final lastMessageContent = lastChat != null
        ? lastChat['message']['content'].toString()
        : 'No messages yet';

    return ListTile(
      // leading: CircleAvatar(
      //   // Replace the avatarUrl with the actual URL of the user's avatar
      //   backgroundImage:
      //       NetworkImage(user['avatarUrl']), // Access the fields correctly
      // ),
      title: Text(profileData['username'].toString()),
      subtitle: Text(lastMessageContent),
      onTap: () {
        Navigator.pushNamed(context, "/doctors-chatting", arguments: {
          'receiverId': profileData['id'].toString(),
          'receiverName': profileData['username'].toString(),
        });
      },
    );
  }
}
