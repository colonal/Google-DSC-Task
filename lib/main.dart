import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/home_screen.dart';
import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

bool? isLogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      print('User is currently signed out!');
      isLogin = true;
    } else {
      print('User is signed in!');
      try {
        final get = FirebaseFirestore.instance;
        userModel = UserModel.fromMap(
            await get.collection("users").doc(user.uid).get());
        isLogin = false;
      } catch (_) {
        isLogin = true;
      }
      print("Home >>>>");
    }
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLogin == null
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isLogin!
              ? const LoginScreen()
              : const HomeScreen(),
    );
  }
}
