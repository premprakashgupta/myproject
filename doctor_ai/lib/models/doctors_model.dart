import 'dart:convert';

import 'package:doctor_ai/models/user_model.dart';

class DoctorsModel {
  final String city;
  final String degree;
  final String distric;
  final String hospitalName;
  final String specialist;
  final List tags;
  final double pin;
  final double experience;
  final double rating;
  final UserModel ref;
  final String state;
  DoctorsModel({
    required this.city,
    required this.degree,
    required this.distric,
    required this.hospitalName,
    required this.specialist,
    required this.tags,
    required this.pin,
    required this.experience,
    required this.rating,
    required this.ref,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'degree': degree,
      'distric': distric,
      'hospitalName': hospitalName,
      'specilist': specialist,
      'tags': tags,
      'pin': pin,
      'experience': experience,
      'rating': rating,
      'ref': ref,
      'state': state,
    };
  }

  factory DoctorsModel.fromMap(Map<String, dynamic> map) {
    return DoctorsModel(
      city: map['city'] as String,
      degree: map['degree'] as String,
      distric: map['distric'] as String,
      hospitalName: map['hospitalName'] as String,
      specialist: map['specialist'] as String,
      tags: map['tags'] as List,
      pin: map['pin'],
      experience: map['experience'],
      rating: map['rating'],
      ref: UserModel.fromMap(map['ref']),
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorsModel.fromJson(String source) =>
      DoctorsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DoctorsModel(city: $city, degree: $degree, distric: $distric, hospitalName: $hospitalName,  pin: $pin, rating: $rating, ref: $ref, state: $state)';
  }

  @override
  bool operator ==(covariant DoctorsModel other) {
    if (identical(this, other)) return true;

    return other.city == city &&
        other.degree == degree &&
        other.distric == distric &&
        other.hospitalName == hospitalName &&
        other.pin == pin &&
        other.rating == rating &&
        other.ref == ref &&
        other.state == state;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        degree.hashCode ^
        distric.hashCode ^
        hospitalName.hashCode ^
        pin.hashCode ^
        rating.hashCode ^
        ref.hashCode ^
        state.hashCode;
  }
}
