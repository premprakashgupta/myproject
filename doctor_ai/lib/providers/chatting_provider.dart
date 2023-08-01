import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:flutter/material.dart';

class ChattingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _chatMessages = [];

  // Getter method to access the chat messages
  List<Map<String, dynamic>> get chatMessages => _chatMessages;

  // Setter method to add a new chat message
  void addChatMessage({required Map<String, dynamic> data}) {
    _chatMessages.add(data);
    notifyListeners();
  }

  // Setter method to clear all chat messages
  void clearChatMessages() {
    _chatMessages.clear();
  }

  Future<void> fetchChatsPF({required String receiverId}) async {
    var res = await FirestoreService().fetchChat(receiverId: receiverId);
    _chatMessages = res;
    print("chatting provider $res");
    notifyListeners();
  }
}
