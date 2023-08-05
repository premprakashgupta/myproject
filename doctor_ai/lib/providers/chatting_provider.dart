import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:doctor_ai/utility/msg_store.dart';
import 'package:flutter/material.dart';

class ChattingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _chatMessages = [];

  // Getter method to access the chat messages
  List<Map<String, dynamic>> get chatMessages => _chatMessages;

  // Setter method to add a new chat message
  void addChatMessage(
      {required Map<String, dynamic> data, required String receiverId}) async {
    bool receiverIdFound = false;

    // Find the receiverId in _chatMessages
    for (var i = 0; i < 3; i++) {
      print("add chat pp  call hghgfh");
    }
    for (var chatMessage in _chatMessages) {
      print("loop run");
      if (chatMessage["profileData"]["id"].toString() == receiverId) {
        (chatMessage["chats"] as List).add(data);
        receiverIdFound = true;
        break;
      }
    }
    // if it is first time then add whole profile

    // If receiverId is not found, create a new entry in _chatMessages
    if (!receiverIdFound) {
      var userData = await FirestoreService().getUserData(userUid: receiverId);
      if (userData != null) {
        print(userData);
        _chatMessages.add({
          "profileData": userData,
          "chats": [data],
        });
      }
    }

    // Store the updated _chatMessages in the local file
    MsgStore().storeChatMessageLocally(data, receiverId);

    notifyListeners();
  }

  // Setter method to clear all chat messages
  void clearChatMessages() {
    _chatMessages.clear();
  }

  Future<void> fetchChatsPF() async {
    var res = await MsgStore()
        .loadLocalDB(); // Load all chat messages from local file
    // var res = await FirestoreService().fetchAllChats(); // Load all chat messages from Firestore

    // Update the _chatMessages list with the loaded data
    _chatMessages = res;

    // Fetch profile data for each receiverId from Firestore and update _chatMessages
    for (var chatData in _chatMessages) {
      if (chatData.containsKey("profileData") &&
          chatData["profileData"] != null) {
        String profileId = chatData["profileData"];
        // Fetch the user data from Firestore using the profileId value
        var userData = await FirestoreService().getUserData(userUid: profileId);
        if (userData != null) {
          chatData["profileData"] = userData; // Update profile data
        }
      }
    }

    notifyListeners();
  }
}
