import 'package:flutter/material.dart';
import '../app_databases/my_app_database.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile Screen"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: MyAppDatabase.getUserDetails(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return Card(
                child: ListTile(
                  title: Text(snapShot.data!.userName),
                  subtitle: Text(snapShot.data!.email),
                ),
              );
            }else if(snapShot.hasError){
              return Text("error");
            }else{
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}
