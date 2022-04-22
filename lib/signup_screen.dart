import 'package:dsc_task/home_screen.dart';
import 'package:dsc_task/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUZKmoD95W6yIrICkkXzSixS_RufP25ZYp9w&usqp=CAU"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Name",
                      border: OutlineInputBorder()),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.phone),
                    hintText: 'Enter a Phone Number',
                    labelText: 'Phone',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: "Email Address",
                      border: OutlineInputBorder()),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: "Password",
                      border: OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: "RePassword",
                      border: OutlineInputBorder()),
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
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      text: "have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(
                            text: "Login",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
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
