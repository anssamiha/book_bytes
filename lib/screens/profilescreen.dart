import 'package:book_bytes/models/user.dart';
import 'package:book_bytes/screens/loginscreen.dart';
import 'package:book_bytes/screens/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:book_bytes/shared/mydrawer.dart';

class ProfileScreen extends StatefulWidget {
  final User userdata;
  const ProfileScreen({super.key, required this.userdata});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Profile",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.purple,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          page: 'profile',
          userdata: widget.userdata,
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const RegistrationScreen()));
                },
                child: Text("Register")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const LoginScreen()));
                },
                child: Text("Login"))
          ]),
        ));
  }
}
