import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:book_bytes/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String eula = "";
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration Form")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/register.jpg"),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.person),
                            ),
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "name must be longer than 3"
                                : null,
                          ),
                          TextFormField(
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "enter a valid email"
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
                            validator: (val) =>
                                validatePassword(val.toString()),
                          ),
                          TextFormField(
                            controller: _pass2EditingController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Re-enter Password',
                              icon: Icon(Icons.lock),
                            ),
                            validator: (val) =>
                                validatePassword(val.toString()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: _showEULA,
                                child: const Text("Agree with terms?"),
                              ),
                              ElevatedButton(
                                onPressed: _registerUserDialog,
                                child: const Text("Register"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUserDialog() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please accept EULA"),
        backgroundColor: Colors.purple,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registration Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registerUser() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/book_bytes/php/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "password": _pass
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
