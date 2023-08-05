import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MsgStore {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> storeChatMessageLocally(
      Map<String, dynamic> data, String receiverId) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> chatData = [];

    final existingDataString = prefs.getString(userId) ??
        '[]'; // Initialize with an empty array if no data is found
    if (existingDataString.isNotEmpty) {
      chatData = jsonDecode(existingDataString).cast<Map<String, dynamic>>();
    }

    // Search for the profileData in the chatData list
    bool found = false;
    for (var chat in chatData) {
      if (chat.containsKey("profileData") &&
          chat["profileData"] == receiverId) {
        (chat["chats"] as List).add(data);
        found = true;
        break;
      }
    }

    // If the profileData not found, create a new entry in the chatData list
    if (!found) {
      chatData.add({
        "profileData": receiverId,
        "chats": [data],
      });
    }

    // Serialize and update the data in SharedPreferences
    final updatedDataString = jsonEncode(chatData);
    prefs.setString(userId, updatedDataString);
  }

  Future<List<Map<String, dynamic>>> loadLocalDB() async {
    final prefs = await SharedPreferences.getInstance();

    final existingDataString = prefs.getString(userId) ?? '[]';

    if (existingDataString.isEmpty) {
      return [];
    }

    final chatData =
        jsonDecode(existingDataString).cast<Map<String, dynamic>>();

    return chatData;
  }
}
