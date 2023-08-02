import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class MsgStore {
  String _serializeAndEncrypt(List<Map<String, dynamic>> data) {
    final jsonData = jsonEncode(data);
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    return encrypted.base64;
  }

  Future<void> storeChatMessageLocally(
      Map<String, dynamic> data, String receiverId) async {
    // final encryptedData = _serializeAndEncrypt(data);
    final folder = await getExternalStorageDirectory();
    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    if (!await myFlutterFolder.exists()) {
      await myFlutterFolder.create(recursive: true);
    }

    final file =
        File('${myFlutterFolder.path}/receiver_${receiverId}_chats.dat');
    List<Map<String, dynamic>> existingData = [];

    if (await file.exists()) {
      // If the file exists, load the existing data and deserialize it
      final encryptedExistingData = await file.readAsString();
      if (encryptedExistingData.isNotEmpty) {
        // existingData = _decryptAndDeserialize(encryptedExistingData);
        existingData = _decryptAndDeserialize(encryptedExistingData);
      }
    }

    // Append the new message to the existing data list
    existingData.add(data);

    // Serialize and encrypt the updated data list
    final encryptedUpdatedData = _serializeAndEncrypt(existingData);

    // Write the updated data to the file
    await file.writeAsString(encryptedUpdatedData, flush: true);

    print('${myFlutterFolder.path}/receiver_${receiverId}_chats.dat');
  }

  Future<List<Map<String, dynamic>>> loadChatsForReceiver(
      String receiverId) async {
    final folder = await getExternalStorageDirectory();
    final myFlutterFolder = Directory('${folder!.path}/myflutter');
    final file =
        File('${myFlutterFolder.path}/receiver_${receiverId}_chats.dat');
    print(
        'file search at ${myFlutterFolder.path}/receiver_${receiverId}_chats.dat');
    print("------------------ file $file");
    if (!await file.exists()) {
      return [];
    }
    final encryptedData = await file.readAsString();
    print('Encrypted Data: $encryptedData');
    final decryptedData = _decryptAndDeserialize(encryptedData);
    print('Decrypted Data: $decryptedData');
    return decryptedData;
  }

  // Decryption and Deserialization (Example, you may use your own deserialization method)
  List<Map<String, dynamic>> _decryptAndDeserialize(String encryptedData) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    try {
      final decryptedData = encrypter.decrypt64(encryptedData, iv: iv);
      final jsonData = jsonDecode(decryptedData);

      if (jsonData is List) {
        return jsonData.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error while decrypting and deserializing: $e');
    }

    return [];
  }
}
