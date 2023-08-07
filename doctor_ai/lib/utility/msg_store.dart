import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class MsgStore {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String _serializeAndEncrypt(List<Map<String, dynamic>> data) {
    final jsonData = jsonEncode(data);
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    return encrypted.base64;
  }

  List<Map<String, dynamic>> _decryptAndDeserialize(String encryptedData) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    try {
      final decryptedData = encrypter.decrypt64(encryptedData, iv: iv);
      final jsonData = jsonDecode(decryptedData);

      if (jsonData is List) {
        return List<Map<String, dynamic>>.from(jsonData);
      }
    } catch (e) {
      print('Error while decrypting and deserializing: $e');
    }

    return [];
  }

  Future<void> storeChatMessageLocally(
      Map<String, dynamic> data, String receiverId) async {
    final folder = await getExternalStorageDirectory();
    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    if (!await myFlutterFolder.exists()) {
      await myFlutterFolder.create(recursive: true);
    }

    final file = File('${myFlutterFolder.path}/${userId}_chatdb.dat');
    List<Map<String, dynamic>> chatData = [];

    if (await file.exists()) {
      final encryptedExistingData = await file.readAsString();
      if (encryptedExistingData.isNotEmpty) {
        chatData = _decryptAndDeserialize(encryptedExistingData);
      }
    }

    // Search for the receiverId in the chatData list
    bool found = false;
    for (var chat in chatData) {
      if (chat['profileData'] == receiverId) {
        (chat['chats'] as List).add(data);
        found = true;
        break;
      }
    }

    // If the receiverId not found, create a new entry in the chatData list
    if (!found) {
      chatData.add({
        'profileData': receiverId,
        'chats': [data],
      });
    }

    // Serialize and encrypt the updated data
    final encryptedUpdatedData = _serializeAndEncrypt(chatData);

    // Write the updated data to the file
    await file.writeAsString(encryptedUpdatedData, flush: true);
  }

  Future<List<Map<String, dynamic>>> loadLocalDB() async {
    final folder = await getExternalStorageDirectory();

    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    final file = File('${myFlutterFolder.path}/${userId}_chatdb.dat');

    if (!await file.exists()) {
      return [];
    }

    final encryptedData = await file.readAsString();
    final decryptedData = _decryptAndDeserialize(encryptedData);

    return decryptedData;
  }
}
