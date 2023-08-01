import 'dart:convert';
import 'package:doctor_ai/firebase/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:doctor_ai/models/doctors_model.dart';

class DoctorProvider with ChangeNotifier {
  List<DoctorsModel> _doctorsList = [];

  // Getter for the list of doctors
  List<DoctorsModel> get doctorsList => _doctorsList;

  Future<void> fetchDoctorList() async {
    var res = await FirestoreService().fetchDoctorData();
    print("----- doctor provider res--- $res");
    if (res != null) {
      _doctorsList = res.map((map) => DoctorsModel.fromMap(map)).toList();
    } else {
      _doctorsList = [];
    }
    print("----- doctor provider --- $_doctorsList");
    notifyListeners();
  }

  // Add a new doctor to the list
  void addDoctor(DoctorsModel doctor) {
    _doctorsList.add(doctor);
    notifyListeners();
  }

  // Update an existing doctor in the list
  // void updateDoctor(DoctorsModel updatedDoctor) {
  //   final index =
  //       _doctorsList.indexWhere((doctor) => doctor.id == updatedDoctor.id);
  //   if (index != -1) {
  //     _doctorsList[index] = updatedDoctor;
  //     notifyListeners();
  //   }
  // }

  // Remove a doctor from the list
  // void removeDoctor(String doctorId) {
  //   _doctorsList.removeWhere((doctor) => doctor.id == doctorId);
  //   notifyListeners();
  // }

  // Convert the list of doctors to JSON
  String toJson() {
    final List<Map<String, dynamic>> doctorMaps =
        _doctorsList.map((doctor) => doctor.toMap()).toList();
    return json.encode(doctorMaps);
  }

  // Initialize the list of doctors from JSON
  void fromJson(String jsonSource) {
    final List<dynamic> doctorMaps = json.decode(jsonSource);
    _doctorsList = doctorMaps.map((map) => DoctorsModel.fromMap(map)).toList();
    notifyListeners();
  }
}
