import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIO {
  io.Socket? socket;

  io.Socket? connectToServer(String userId) {
    // socket = io.io('ws://10.0.2.2:5000', <String, dynamic>{
    //   'transports': ['websocket'],
    // }); //emulator
    // socket = io.io('http://127.0.0.1:5000', <String, dynamic>{
    //   'transports': ['websocket'],
    // }); //website
    socket = io.io('http://192.168.152.3:5000', <String, dynamic>{
      'transports': ['websocket'],
    }); // real device
    // socket = io.io('ws://localhost:5000', <String, dynamic>{
    //   'transports': ['websocket'],
    // }); //website

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
    print("sendMessage $receiverId");
    socket!.emit('message', {
      'senderId': userId,
      'receiverId': receiverId,
      'message': message,
    });
  }
}
