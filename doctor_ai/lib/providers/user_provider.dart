import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:doctor_ai/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }

  Future<void> userDataProvider() async {
    var res = await FirestoreService().getUserData();
    _user = UserModel.fromMap(res!);
    print("----------- user provider --------- $_user");
    notifyListeners();
  }
}
