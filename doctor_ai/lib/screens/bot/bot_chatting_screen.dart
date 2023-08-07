import 'package:flutter/scheduler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class BotChattingScreen extends StatefulWidget {
  const BotChattingScreen({super.key});

  @override
  _BotChattingScreenState createState() => _BotChattingScreenState();
}

class _BotChattingScreenState extends State<BotChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late FlutterTts flutterTts;
  bool speak = false;
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'sender': 'bot',
      'message': {
        'content': 'Hey There! How Can I Help You',
        'image':
            'https://static.vecteezy.com/system/resources/previews/004/996/790/original/robot-chatbot-icon-sign-free-vector.jpg',
      },
      'time': DateTime.now(),
    },
  ];

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
  }

  Future<Map<String, dynamic>> fetchBotResponse(String message) async {
    var url = Uri.parse("http://192.168.152.3:5000/bot_response");
    //web:      http: //localhost:5000
    // android: http://10.0.2.2:5000
    var headers = {"Content-Type": "application/json"};
    var body = {"message": message, "user_id": "xfx6rgbjhvwawa"};

    var response =
        await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['response'];
    } else {
      // Handle error if needed
      return {'content': "Error occurred", 'image': ''};
    }
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    var response = await fetchBotResponse(message);

    setState(() {
      _chatMessages.add({
        'sender': 'user',
        'message': {'content': message, 'image': ''},
        'time': DateTime.now(),
      });

      _chatMessages.add({
        'sender': 'bot',
        'message': {'content': response['content'], 'image': response['image']},
        'time': DateTime.now(),
      });

      _messageController.clear();
    });

    _speak(response['content']);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        speak = true; // Set speak to true before speaking
      });

      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text);

      setState(() {
        speak = false; // Set speak to false after speaking
      });
    }
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() => speak = false);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Dr.AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                var messageData = _chatMessages[index];
                var sender = messageData['sender'];
                Map<String, dynamic> message = messageData['message'];

                return Align(
                  alignment:
                      sender == 'user' ? Alignment.topRight : Alignment.topLeft,
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: sender == 'user'
                              ? Colors.greenAccent.shade100
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: sender == 'user'
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
                            crossAxisAlignment: sender == 'user'
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              message['image'] != ''
                                  ? CachedNetworkImage(
                                      imageUrl: message['image'],
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : const SizedBox(),
                              Text(
                                message['content'],
                                style: TextStyle(
                                  color: sender == 'user'
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
                        child: sender == 'user'
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
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _messageController,
                    onSubmitted: (value) {
                      _sendMessage(value);
                    },
                    decoration:
                        const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
                speak
                    ? IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => _stop(),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
