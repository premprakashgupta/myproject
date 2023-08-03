import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:doctor_ai/providers/msg_store.dart';
import 'package:flutter/material.dart';

class ChattingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _chatMessages = [];

  // Getter method to access the chat messages
  List<Map<String, dynamic>> get chatMessages => _chatMessages;

  // Setter method to add a new chat message
  void addChatMessage(
      {required Map<String, dynamic> data, required String receiverId}) {
    _chatMessages.add(data);
    // MsgStore().storeChatMessageLocally(data, receiverId);
    print(_chatMessages);
    notifyListeners();
  }

  // Setter method to clear all chat messages
  void clearChatMessages() {
    _chatMessages.clear();
  }

  Future<void> fetchChatsPF({required String receiverId}) async {
    // var res =
    // await MsgStore().loadChatsForReceiver(receiverId); // from local file
    var res = await FirestoreService().fetchChat(receiverId: receiverId);
    // Combine new Firestore data with existing chat messages
    if (res.isNotEmpty) {
      _chatMessages.insertAll(0, res);
      notifyListeners();
    }
  }
}
