import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class MsgStore {
  String _serializeAndEncrypt(Map<String, dynamic> data) {
    final jsonData = jsonEncode(data);
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    return encrypted.base64;
  }

  Future<void> storeChatMessageLocally(
      Map<String, dynamic> data, String receiverId) async {
    final folder = await getExternalStorageDirectory();
    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    if (!await myFlutterFolder.exists()) {
      await myFlutterFolder.create(recursive: true);
    }

    final file = File('${myFlutterFolder.path}/chatdb.dat');
    Map<String, dynamic> chatData = {};

    if (await file.exists()) {
      final encryptedExistingData = await file.readAsString();
      if (encryptedExistingData.isNotEmpty) {
        final decryptedData = _decryptAndDeserialize(encryptedExistingData);
        if (decryptedData is Map) {
          chatData = Map.from(decryptedData);
        }
      }
    }

    // Update the chat data for the receiver
    if (!chatData.containsKey(receiverId)) {
      chatData[receiverId] = [];
    }
    (chatData[receiverId] as List).add(data);

    // Serialize and encrypt the updated data
    final encryptedUpdatedData = _serializeAndEncrypt(chatData);

    // Write the updated data to the file
    await file.writeAsString(encryptedUpdatedData, flush: true);

    print('${myFlutterFolder.path}/chatdb.dat');
  }

  Future<List<Map<String, dynamic>>> loadChatsForReceiver(
      String receiverId) async {
    final folder = await getExternalStorageDirectory();
    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    final file = File('${myFlutterFolder.path}/chatdb.dat');

    if (!await file.exists()) {
      return [];
    }
    final encryptedData = await file.readAsString();
    final decryptedData = _decryptAndDeserialize(encryptedData);

    if (decryptedData is Map && decryptedData.containsKey(receiverId)) {
      return List<Map<String, dynamic>>.from(decryptedData[receiverId]);
    }

    return [];
  }

  // Decryption and Deserialization (Example, you may use your own deserialization method)
  Map<String, dynamic> _decryptAndDeserialize(String encryptedData) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    try {
      final decryptedData = encrypter.decrypt64(encryptedData, iv: iv);
      final jsonData = jsonDecode(decryptedData);

      if (jsonData is Map) {
        return jsonData as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error while decrypting and deserializing: $e');
    }

    return {};
  }
}
