import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/build_text_field_widget.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import '../user.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontSize: 40,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: Image.asset("assets/images/login.gif"),
                        ),
                      ),
                      buildTextField(
                        text: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
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
                          emailController.text = value!;
                        },
                      ),
                      buildTextField(
                        text: "Password",
                        keyboardType: TextInputType.visiblePassword,
                        controller: passController,
                        isPass: true,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey[700]!,
                                  Colors.grey[900]!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    offset: const Offset(2, 3))
                              ]),
                          child: MaterialButton(
                            onPressed: () => signIn(
                                emailController.text, passController.text),
                            // color: Colors.black,
                            child: isLoding
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                                text: "Dont have an account? ",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                children: [
                                  TextSpan(
                                      text: "Sign Up",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SignUpScreen()));
                                        }),
                                ]),
                          ),
                        ),
                      ),
                    ]),
              ),
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
            .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
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
