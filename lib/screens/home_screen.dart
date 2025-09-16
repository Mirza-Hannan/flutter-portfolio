import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_auth/screens/login_screen.dart';
import 'package:login_signup_auth/screens/profile_screen.dart';

import '../app_databases/my_app_database.dart';
import '../authentications/auth_services.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  Future<void> editUser(
      {required userName,
        required email,
        required id}) async {
    nameCtrl.text = userName;
    emailCtrl.text = email;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit User Details"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                        labelText: "User Name",
                        hintText: "Enter User Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                        labelText: "User Email",
                        hintText: "Enter User Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Enter Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    MyAppDatabase.editUser(
                        userID: id,
                        userName: nameCtrl.text,
                        email: emailCtrl.text,
                    );
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text("Edit"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home screen", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(onPressed: () {
              AppAuthService.logOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
            }, icon: Icon(Icons.logout)),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(CupertinoIcons.profile_circled)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Users",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: MyAppDatabase.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong ❌"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No users found 😕"));
                  }

                  final users = snapshot.data!;
                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              user.userName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  editUser(
                                    userName: user.userName,
                                    email: user.email,
                                    id: user.id,
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.green),
                              ),
                              IconButton(
                                onPressed: () {
                                  MyAppDatabase.deleteDetails(user.id);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
