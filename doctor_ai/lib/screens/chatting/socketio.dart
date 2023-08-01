import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIO {
  io.Socket? socket;

  io.Socket? connectToServer(BuildContext context, String userId) {
    socket = io.io('ws://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      print('Connected to the server');
      socket!.emit('join', {userId});
    });

    socket!.onConnectError((data) {
      print('Connection error: $data');
    });

    socket!.onConnectTimeout((data) {
      print('Connection timeout: $data');
    });
    socket!.onDisconnect((_) {
      print('Disconnected from the server');
    });
    return socket;
  }

  void sendMessage(
      String userId, String receiverId, Map<String, dynamic> message) {
    socket!.emit('message', {
      'senderId': userId,
      'receiverId': receiverId,
      'message': message,
    });
  }
}
