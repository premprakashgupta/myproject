import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_ai/providers/chatting_provider.dart';
import 'package:doctor_ai/providers/socketio_provider.dart';

import 'package:doctor_ai/screens/chatting/speech_to_text.dart';
import 'package:doctor_ai/utility/custom_snacbar.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final userId = FirebaseAuth.instance.currentUser!.uid;

  io.Socket? socket;
  final SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition();
    socket = Provider.of<SocketProvider>(context, listen: false).socket;
  }

  void _initializeSpeechRecognition() async {
    await speechToText.initialize();
  }

  void _startListening() {
    speechToText.startListening((String recognizedText) {
      _inputController.text = recognizedText;
    });
  }

  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  void _sendMessage({required String receiverId}) {
    String message = _inputController.text;

    socket!.emit('message', {
      'senderId': userId,
      'receiverId': receiverId,
      'message': {'content': message, 'image': ''},
    });
    Provider.of<ChattingProvider>(context, listen: false).addChatMessage(
      data: {
        'sender': userId,
        'receiver': receiverId,
        'message': {'content': message, 'image': ""}
      },
      receiverId: receiverId,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });

    _inputController.clear();
  }

  @override
  void dispose() {
    print("------- dispose");

    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${arguments["receiverName"]}'),
      ),
      body: Column(
        children: [
          Text("me : $userId"),
          Text("receiverId : ${arguments['receiverId']}"),
          Consumer<ChattingProvider>(
            builder: (context, chattingProvider, _) {
              List<Map<String, dynamic>> chatMessages =
                  chattingProvider.chatMessages;
              if (chatMessages.isEmpty) {
                return Expanded(
                  child: Text("No data found chat is empty"),
                );
              }

              // Find the chat data for the current receiverId
              late Map<String, dynamic>? chatData;
              for (var element in chatMessages) {
                if (element['profileData']['id'].toString() ==
                    arguments["receiverId"]) {
                  chatData = element;
                }
              }

              print(chatData);
              // return SizedBox();
              print("consumer run");

              if (chatData!.isEmpty) {
                return Expanded(
                  child: Text("No chat data found chat data empty"),
                );
              }

              List<dynamic> chats = chatData['chats'];

              return Expanded(
                child: ListView.builder(
                  itemCount: chats.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    var messageData = chats[index];
                    var sender = messageData['sender'];
                    Map<String, dynamic> message = messageData['message'];

                    return Align(
                      alignment: sender == userId
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            decoration: BoxDecoration(
                              color: sender == userId
                                  ? Colors.greenAccent.shade100
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: sender == userId
                                    ? Colors.green
                                    : Colors.blue.shade300,
                                width: 1,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                              child: Column(
                                crossAxisAlignment: sender == userId
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  message['image'] != ''
                                      ? CachedNetworkImage(
                                          imageUrl: message['image'],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : const SizedBox(),
                                  Text(
                                    message['content'],
                                    style: TextStyle(
                                      color: sender == userId
                                          ? Colors.white
                                          : Colors.blue.shade300,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.right,
                                    "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: sender == userId
                                ? const CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      "https://img.freepik.com/free-vector/mysterious-mafia-man-smoking-cigarette_52683-34828.jpg?size=626&ext=jpg",
                                    ),
                                  )
                                : const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "https://static.vecteezy.com/system/resources/previews/004/996/790/original/robot-chatbot-icon-sign-free-vector.jpg",
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _sendMessage(receiverId: arguments['receiverId']);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // handleSend();
                    _sendMessage(receiverId: arguments['receiverId']);
                  },
                  icon: const Icon(Icons.send),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: speechToText.isListening,
                      replacement: ElevatedButton(
                        onPressed: () {
                          _startListening;
                        },
                        child: const Icon(Icons.mic),
                      ),
                      child: Image.asset(
                        "assets/images/sound.gif",
                        width: 20,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String type;
  final String message;
  final String userId;

  const ChatBubble({
    super.key,
    required this.type,
    required this.message,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment:
            type == userId ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: type == userId ? Colors.greenAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message,
            style:
                TextStyle(color: type == userId ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
