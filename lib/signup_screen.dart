import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/login_screen.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isLoding = false;
  String? errorMessage;

  late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.8),
            ])),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.asset("assets/images/1.png"),
                    ),
                    buildTextField(
                      controller: nameController,
                      text: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[50],
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{4,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 4 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nameController.text = value!;
                      },
                    ),
                    buildTextField(
                      controller: phoneController,
                      text: 'Phone',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey[50],
                      ),
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
                        passController.text =
                            value!; // GETTING the value of edit text
                      },
                    ),
                    buildTextField(
                      controller: emailController,
                      text: "Email Address",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                    buildTextField(
                      controller: passController,
                      text: "Password",
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.grey[50],
                      ),
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
                    buildTextField(
                      text: "RePassword",
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      isPass: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (passController.text != value) {
                          return ("Not Match");
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
                          onPressed: () => signUp(
                              nameController.text,
                              phoneController.text,
                              emailController.text,
                              passController.text),
                          child: isLoding
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                            text: "have an account? ",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                  text: "Login",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LoginScreen()));
                                    }),
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
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

  void signUp(String name, String phone, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoding = !isLoding;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => postDetailsToFirestore())
          .catchError((error, stackTrace) {
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
        print(error.code);

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
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    print("nameController.text: ${nameController.text}");
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.phone = phoneController.text;
    userModel.cardKey = genaret();
    userModel.endDate = endDate();
    userModel.money = 500.0;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OTPScreen(auth: _auth, userModel: userModel)));
  }
}

String genaret() {
  return random().toString() +
      random().toString() +
      random().toString() +
      random().toString();
}

int random() {
  return 1000 + Random().nextInt(9999 - 1000);
}

String endDate() {
  String month = DateTime.now().month.toString().length == 1
      ? "0${DateTime.now().month}"
      : DateTime.now().month.toString();

  int year = DateTime.now().year + 4;

  return "$month/$year";
}
