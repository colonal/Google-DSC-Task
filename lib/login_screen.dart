import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/signup_screen.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  UserModel userModel = UserModel();

  bool isLoding = false;

  late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  String? errorMessage;
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
            child: Form(
              key: _formKey,
              child: Column(children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYFqufRoE50kdbNP20g4y_5xxaDehc1bCIOg&usqp=CAU"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Email");
                      }

                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please Enter a valid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      emailController.text =
                          value!; // GETTING the value of edit text
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passController,
                    decoration: const InputDecoration(
                        labelText: "Password", border: OutlineInputBorder()),
                    obscureText: true,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 6 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      passController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () =>
                        signIn(emailController.text, passController.text),
                    color: Colors.black,
                    child: isLoding
                        ? const CircularProgressIndicator()
                        : const Text(
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
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
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoding = !isLoding;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async {
        final get = FirebaseFirestore.instance;
        userModel = UserModel.fromMap(
            await get.collection("users").doc(uid.user!.uid).get());
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen(userModel)));
      }).catchError((error) {
        try {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";

              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          // Fluttertoast.showToast(msg: errorMessage!);
          // print(error.code);
          setState(() {
            isLoding = !isLoding;
          });
          SnackBar snackBar = SnackBar(
              backgroundColor: Colors.red.withOpacity(0.8),
              content: Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } catch (_) {
          print(error.toString());
          SnackBar snackBar = SnackBar(
              backgroundColor: Colors.red.withOpacity(0.8),
              content: Text(
                error.toString(),
                textAlign: TextAlign.center,
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }
}
