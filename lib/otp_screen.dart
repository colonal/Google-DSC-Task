import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final UserModel userModel;
  const OTPScreen({required this.auth, required this.userModel, Key? key})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List images = [
    "https://ouch-cdn2.icons8.com/R1SUR5BD6JUGreEgxYBUBw0LBJKzHeM6VTYmtfmoQRY/rs:fit:256:218/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMzAv/MzA3NzBlMGUtZTgx/YS00MTZkLWI0ZTYt/NDU1MWEzNjk4MTlh/LnN2Zw.png",
    "https://ouch-cdn2.icons8.com/jUVsvGx8nL0aKho6aX4TezGZa23zFoFBa9-TszvXULs/rs:fit:256:256/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzkw/Lzg2NDVlNDllLTcx/ZDItNDM1NC04YjM5/LWI0MjZkZWI4M2Zk/MS5zdmc.png",
    "https://ouch-cdn2.icons8.com/Vi8Baseh8toX5zlLptHjk5grvmTWdY-3pYT4HifsmJc/rs:fit:256:256/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvODA3/LzlkYjc1NmZlLTgz/MTctNDAzZC04NTNj/LThmZjRkNDAyZDc3/NS5zdmc.png",
  ];
  bool isLogeing = false;
  bool isCheck = false;
  int selectImage = 0;
  late Timer timer;
  String binCode = "";
  final changeImage = Stream.periodic(const Duration(seconds: 5), (index) {
    // debugPrint("$index");
  });
  late StreamSubscription changeImageListen;
  @override
  void initState() {
    changeImageListen = changeImage.listen((event) {
      setState(() {
        ++selectImage;
      });
      if (selectImage == images.length) {
        selectImage = 0;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    changeImageListen.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      height: size.height * 0.4,
                      child: Stack(children: [
                        for (var i = 0; i < images.length; ++i)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(seconds: 1),
                              opacity: selectImage == i ? 1 : 0,
                              child: Image.network(
                                images[selectImage],
                              ),
                            ),
                          ),
                      ]),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "BIN Code",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please enter the 4 digit Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                    verification(),
                    const SizedBox(height: 30),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLogeing = !isLogeing;
                        });
                        timer = Timer(const Duration(seconds: 3), () {
                          setState(() {
                            isLogeing = !isLogeing;
                            isCheck = !isCheck;
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color.fromARGB(255, 23, 44, 60),
                                  Colors.black.withOpacity(0.9),
                                ])),
                        child: Center(
                            child: isLogeing
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : (isCheck
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Verify",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView newMethod(Size size) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      itemBuilder: (context, index) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: selectImage == index ? 1 : 0,
        child: Column(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                height: size.height * 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verification() {
    return OtpTextField(
      numberOfFields: 4,
      borderColor: const Color(0xFF512DA8),
      //set to true to show as box or false to show as dash
      showFieldAsBox: true,
      textStyle: const TextStyle(color: Colors.white),
      //runs when a code is typed in
      onCodeChanged: (String code) {
        //handle validation or checks here
      },
      //runs when every textfield is filled
      onSubmit: (String verificationCode) {
        debugPrint("verificationCode: $verificationCode");
        binCode = verificationCode;
      }, // end onSubmit
    );
  }

  void submit() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = widget.auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .set({"binCode": binCode});

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => HomeScreen(widget.userModel)));
  }
}
