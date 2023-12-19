import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:book_bytes/screens/mainscreen.dart';
import 'package:book_bytes/screens/profilescreen.dart';
import 'EnterExitRoute.dart';

class MyDrawer extends StatefulWidget {
  final String page;
  final User userdata;

  const MyDrawer({Key? key, required this.page, required this.userdata})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text('Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Buy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(userdata: widget.userdata),
                      enterPage: MainScreen(userdata: widget.userdata)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "profile") {
                //  Navigator.pop(context);
                return;
              }
              Navigator.pop(context);

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (content) => const ProfileScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: ProfileScreen(userdata: widget.userdata),
                      enterPage: ProfileScreen(userdata: widget.userdata)));
            },
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
