import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                const Color.fromARGB(255, 23, 44, 60),
                Colors.black.withOpacity(0.9),
              ])),
        ),
        SafeArea(
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        enabled = !enabled;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          "Edit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[200]!,
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
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
                    child: InkWell(
                      onTap: () {
                        update();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: isLoding
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Update",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[200]!,
                                    fontSize: 20,
                                    letterSpacing: 2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ))
      ]),
    );
  }

  Padding buildTextField(
      {TextEditingController? controller,
      String? text,
      Widget? prefixIcon,
      bool isPass = false,
      TextInputType? keyboardType,
      String? Function(String?)? validator,
      Function(String?)? onSaved}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            prefixIconColor: Colors.grey[50],
            labelText: text,
            labelStyle: TextStyle(color: Colors.grey[50]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.6), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
          ),
          obscureText: isPass,
          validator: validator,
          onSaved: onSaved),
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
