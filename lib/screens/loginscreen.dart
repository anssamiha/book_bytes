import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:book_bytes/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;
import 'package:book_bytes/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  @override
  void initState() {
    //
    super.initState();
    loadpref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Image.asset("assets/images/login.png"),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Column(children: [
                        const Text(
                          "User Login",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: _emailditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "Please enter a valid email"
                              : null,
                        ),
                        TextFormField(
                          controller: _passEditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Please enter password"
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    saveremovepref(value!);
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                                const Text("Remember Me"),
                              ]),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _loginUser();
                                },
                                child: const Text("Login"))
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String _email = _emailditingController.text;
    String _pass = _passEditingController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/book_bytes/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          print(user.username);
          print(user.useremail);
          print(user.userid);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void saveremovepref(bool value) async {
    String email = _emailditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //safe pref
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('rem', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
      ));
    } else {
      //remove pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('rem', false);
      _emailditingController.text = '';
      _passEditingController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('rem')) ?? false;
    if (_isChecked) {
      _emailditingController.text = email;
      _passEditingController.text = password;
    }
    setState(() {});
  }
}
