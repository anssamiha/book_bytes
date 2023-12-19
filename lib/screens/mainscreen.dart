import 'package:book_bytes/models/user.dart';
import 'package:book_bytes/shared/mydrawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User userdata;
  const MainScreen({super.key, required this.userdata});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Buy Book",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.deepPurple,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          userdata: widget.userdata,
          page: '',
        ),
        body: const Center(
          child: Text("IN DEVELOPMENT"),
        ));
  }
}
