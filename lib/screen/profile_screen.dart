import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';
import '../widget/build_text_field_widget.dart';
import '../widget/button_widget.dart';

class ProfailScreen extends StatefulWidget {
  const ProfailScreen({Key? key}) : super(key: key);

  @override
  State<ProfailScreen> createState() => _ProfailScreenState();
}

class _ProfailScreenState extends State<ProfailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool show = false;
  bool enabled = false;
  bool isLoding = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  void initState() {
    super.initState();
    phoneController.text = userModel!.phone!;
    emailController.text = userModel!.email!;
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        show = !show;
      });
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

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
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white.withOpacity(0.8),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: userModel!.cardKey!,
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ])),
                      child: !show
                          ? Container()
                          : Center(
                              child: Text(
                                userModel!.name!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.9),
                                  fontSize: 25,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buttonWidget(
                    text: "Edit",
                    onTap: () {
                      setState(() {
                        enabled = !enabled;
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  buildTextField(
                    text: "Email",
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
                      emailController.text =
                          value!; // GETTING the value of edit text
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    text: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Phone");
                      }

                      if (!RegExp(r"[0-9].{8,8}$").hasMatch(value)) {
                        return ("Please Enter a valid Phone");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneController.text =
                          value!; // GETTING the value of edit text
                    },
                  ),
                  const SizedBox(height: 10),
                  if (enabled)
                    buildTextField(
                      controller: passController,
                      text: "Password",
                      keyboardType: TextInputType.visiblePassword,
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
                  const SizedBox(height: 30),
                  AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: enabled ? 1 : 0,
                      child: buttonWidget(
                          text: "Update",
                          isLoding: isLoding,
                          onTap: () {
                            update();
                          })),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  void update() async {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      setState(() {
        isLoding = !isLoding;
      });
      await _auth
          .signInWithEmailAndPassword(
              email: userModel!.email!, password: passController.text)
          .then((userCredential) async {
        userCredential.user!.updateEmail(emailController.text);
        await firebaseFirestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update(
                {"email": emailController.text, "phone": phoneController.text});
        userModel!.email = emailController.text;
        userModel!.phone = phoneController.text;
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.greenAccent.withOpacity(0.8),
            content: const Text(
              "Done Update",
              textAlign: TextAlign.center,
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoding = !isLoding;
          enabled = !enabled;
        });
      }).catchError((error, stackTrace) {
        String errorMessage = "";
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
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        // Fluttertoast.showToast(msg: errorMessage!);

        setState(() {
          isLoding = !isLoding;
        });
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.red.withOpacity(0.8),
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}
