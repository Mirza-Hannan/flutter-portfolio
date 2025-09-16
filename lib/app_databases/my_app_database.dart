import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../custom_widgets/my_toasts.dart';
import '../models/user_model.dart';

class MyAppDatabase {
  static CollectionReference userCollectionReference =
  FirebaseFirestore.instance.collection('users');
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static String? get getCurrentUserID => firebaseAuth.currentUser?.uid;

  static Future<void> addUserToDB({
    required String userID,
    required String userName,
    required String email,
  }) async {
    UserModel userModel = UserModel(
      id: userID,
      userName: userName,
      email: email,
    );

    Map<String, dynamic> dataForFireStore = userModel.toJson();

    await userCollectionReference
        .doc(userID)
        .set(dataForFireStore)
        .then((value) {
      showToast(message: "User added to Firestore ✅");
      print("✅ User document written with ID: $userID");
    }).onError((error, stackTrace) {
      print("🔥 Firestore Error while adding user: $error");
      showToast(message: "❌ Error adding user to Firestore");
    });
  }

  static Stream<List<UserModel>> getAllUsers() {
    return userCollectionReference.snapshots().map((snapshot) {
      List<UserModel> appUsers = [];

      for (var doc in snapshot.docs) {
        try {
          UserModel appUser = UserModel.fromDocumentSnapshot(doc);
          appUsers.add(appUser);
        } catch (e) {
          print("Error parsing user data: $e");
        }
      }

      return appUsers;
    }).handleError((error) {
      print("Firestore Error: $error");
    });
  }

  static Future<UserModel?> getUserDetails() async {
    try {
      final documentSnapshot =
      await userCollectionReference.doc(getCurrentUserID).get();
      if (documentSnapshot.exists) {
        UserModel userDetails =
        UserModel.fromDocumentSnapshot(documentSnapshot);
        return userDetails;
      } else {
        print('Not Exists');
        return null;
      }
    } catch (e) {
      print("Exception occurred..................>$e");
      return null;
    }
  }

  static Future<void> editUser(
      {required userID,
        required userName,
        required email,
      }) async {
    UserModel userUpdatedData = UserModel(
        id: userID, userName: userName, email: email);
    Map<String, dynamic> userDetails = userUpdatedData.toJson();
    userCollectionReference.doc(userID).set(userDetails).then((value) {
      showToast(message: "User Details Edited");
    }).onError((error, stackTrace) {
      showToast(message: "unable to Edit Details");
    });
  }

  static Future<void> deleteDetails(String docID) async {
    try {
      await userCollectionReference.doc(docID).delete();
      showToast(message: "User deleted successfully");
    } catch (e) {
      showToast(message: "unable to delete User");
    }
  }
}
