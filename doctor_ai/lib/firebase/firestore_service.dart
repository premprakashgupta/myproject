import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final CollectionReference usersCollection =
          _firestore.collection('users');
      final userDataSnapshot =
          await usersCollection.doc(_auth.currentUser!.uid).get();

      if (userDataSnapshot.exists) {
        final userData = userDataSnapshot.data();
        if (userData != null) {
          return userData as Map<String, dynamic>;
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
    return null;
  }

  Future<Map<String, dynamic>?> doctorProfile({required String uid}) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> userDocRef =
          firestore.collection('users').doc(uid);

      // Fetch user data
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userDocRef.get();
      Map<String, dynamic>? userData = userSnapshot.data();

      // Fetch doctor data
      Query<Map<String, dynamic>> doctorQuery =
          firestore.collection('doctors').where('ref', isEqualTo: userDocRef);
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await doctorQuery.get();
      Map<String, dynamic> doctorData = querySnapshot.docs.first.data();

      // Merge user and doctor data
      Map<String, dynamic> mergedData = {...doctorData, 'ref': userData};

      print("- doctor profile $mergedData");
      return mergedData;
    } catch (e) {
      // Handle any errors that occur during the fetch process
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchDoctorData() async {
    try {
      List<Map<String, dynamic>> mergedDataList = [];

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference doctorsRef = firestore.collection('doctors');

      // Fetch the initial snapshot of the doctors collection
      QuerySnapshot<Object?> doctorsSnapshot = await doctorsRef.get();

      // Iterate through each doctor document
      for (var doctorDoc in doctorsSnapshot.docs) {
        Map<String, dynamic> doctorData =
            doctorDoc.data() as Map<String, dynamic>;

        // Get the 'ref' field, which should contain a DocumentReference to a user document
        DocumentReference? userRef = doctorData['ref'] as DocumentReference?;
        if (userRef == null) {
          // Handle the case when 'ref' is null or not found in the document
          print('User reference not found for doctor: ${doctorData['id']}');
          continue; // Skip this doctor and proceed to the next one
        }

        DocumentSnapshot userSnapshot = await userRef.get();
        if (!userSnapshot.exists) {
          // Handle the case when the user document doesn't exist
          print('User document not found for doctor: ${doctorData['id']}');
          continue; // Skip this doctor and proceed to the next one
        }

        // Merge the doctorData and userData into a single Map
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> mergedData = {...doctorData, 'ref': userData};
        print("65-------------$mergedData");
        // Create a new DoctorsModel instance using the merged data

        mergedDataList.add(mergedData);
      }

      // Return the mergedDataList as the result of the Future

      print("----- firestore service fetch doctor data --- $mergedDataList");
      return mergedDataList;
    } catch (e) {
      // Handle any errors that occur during the fetch process
      print('Error fetching data: $e');
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> fetchChattingUserList() {
    StreamController<List<Map<String, dynamic>>> controller =
        StreamController();

    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chatting')
        .snapshots()
        .listen((snap) async {
      List<Map<String, dynamic>> list = [];

      for (var doc in snap.docs) {
        var data = doc.data();
        var receiverData =
            await _firestore.collection('users').doc(data['receiver']).get();
        var updatedData = {...data, 'receiver': receiverData.data()};
        list.add(updatedData);
      }

      // Add the updated list to the stream
      controller.add(list);
    });

    // Return the stream from the controller
    return controller.stream;
  }

  Future<void> addSender({required String receiverId}) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chatting')
        .add({
      'sender': _auth.currentUser!.uid,
      'receiver': receiverId,
      'chats': []
    });
  }

  Future<List<Map<String, dynamic>>> fetchChat(
      {required String receiverId}) async {
    QuerySnapshot<Map<String, dynamic>> querysnap = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chatting')
        .where('receiver', isEqualTo: receiverId)
        .get();

    if (querysnap.docs.isNotEmpty) {
      var doc = querysnap.docs.first;
      List<Map<String, dynamic>> chats = (doc.data()['chats'] as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();

      print("---------------------$chats");
      return chats;
    } else {
      return [];
    }
  }
}
