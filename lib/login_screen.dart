import 'package:dsc_task/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYFqufRoE50kdbNP20g4y_5xxaDehc1bCIOg&usqp=CAU"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Email Address", border: OutlineInputBorder()),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                  color: Colors.black,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      text: "Dont have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()));
                              }),
                      ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
