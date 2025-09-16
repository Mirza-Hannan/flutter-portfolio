import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String id;
  late final String userName;
  late final String email;

  UserModel({required this.id, required this.userName, required this.email});

  UserModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    id = documentSnapshot['id'];
    userName = documentSnapshot['userName'];
    email = documentSnapshot['email'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['userName'] = userName;
    data['email'] = email;

    return data;
  }
}
