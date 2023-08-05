import 'package:doctor_ai/providers/chatting_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider with ChangeNotifier {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void connect(BuildContext context) {
    print("connect run");
    _socket = io.io('http://192.168.152.3:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket!.onConnect((_) {
      print('Socket connected');
      socket!.emit('join', userId);
    });

    _socket!.onError((error) {
      print('Socket error: $error');
      // Handle the error as needed, e.g., show an error message to the user
    });

    _socket!.onConnectTimeout((data) {
      print('Socket connection timeout');
      // Handle the timeout, e.g., show a message to the user
    });
    socket!.on('message', (data) {
      print("onMessage --------- $data");
      Provider.of<ChattingProvider>(context, listen: false).addChatMessage(
        data: {
          'sender': data['senderId'],
          'receiver': data['receiverId'],
          'message': data['message']
        },
        receiverId: data['senderId'],
      );
    });
  }
}
