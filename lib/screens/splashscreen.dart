import 'dart:async';
import 'dart:convert';
import 'package:book_bytes/shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // User user = User(
    //     userid: "0",
    //     useremail: "unregistered@email.com",
    //     username: "unregistered",
    //     userdatereg: "",
    //     userpassword: "");
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //             builder: (content) => MainPage(
    //                   userdata: user,
    //                 ))));
    checkandlogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "BookBytes",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          CircularProgressIndicator(),
          Text("Version 0.1")
        ],
      )),
    );
  }

  checkandlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('rem')) ?? false;
    if (rem) {
      http.post(
          Uri.parse("${MyServerConfig.server}/bookbytes/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              userdata: user,
                            ))));
          } else {
            User user = User(
                userid: "0",
                useremail: "unregistered@email.com",
                username: "Unregistered",
                userdatereg: "",
                userpassword: "");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              userdata: user,
                            ))));
          }
        }
      });
    } else {
      User user = User(
          userid: "0",
          useremail: "unregistered@email.com",
          username: "Unregistered",
          userdatereg: "",
          userpassword: "");
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        userdata: user,
                      ))));
    }
  }
}
