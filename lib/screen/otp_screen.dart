import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import '../user.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../widget/background_widget.dart';

class OTPScreen extends StatefulWidget {
  final bool isUpdate;
  final bool screenUpdate;

  const OTPScreen({this.isUpdate = false, this.screenUpdate = false, Key? key})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List images = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
  ];
  bool isLogeing = false;
  bool isCheck = false;
  bool error = false;
  int selectImage = 0;
  Timer? timer;
  String binCode = "";
  late bool isUpdate;
  late bool screenUpdate;

  final changeImage = Stream.periodic(const Duration(seconds: 5), (index) {});
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
    isUpdate = widget.isUpdate;
    screenUpdate = widget.screenUpdate;
    super.initState();
  }

  @override
  void dispose() {
    changeImageListen.cancel();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BackgroundWidget(
        child: SafeArea(
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
                            child: Image.asset(
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
                    widget.isUpdate
                        ? screenUpdate
                            ? "Please enter new bin code"
                            : "Please enter Old bin code"
                        : "Please enter the 4 digit Number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  verification(),
                  const SizedBox(height: 30),
                  if (error)
                    Text(
                      "Error try again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent[200],
                        fontSize: 15,
                      ),
                    ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isLogeing = !isLogeing;

                        error = false;
                      });

                      await submit();
                      setState(() {
                        isLogeing = !isLogeing;
                        isCheck = !isCheck;
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
      autoFocus: true,

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

  Future<void> submit() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (isUpdate && !screenUpdate) {
      UserModel _user = userModel = UserModel.fromMap(
          await firebaseFirestore.collection("users").doc(user!.uid).get());
      if (_user.bin == binCode) {
        // screenUpdate = !screenUpdate;
        // isCheck = !isCheck;
        timer = Timer(const Duration(seconds: 1), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const OTPScreen(
                    isUpdate: true,
                    screenUpdate: true,
                  )));
        });
      } else {
        setState(() {
          error = !error;
          isCheck = !isCheck;
        });
      }
    } else {
      await firebaseFirestore
          .collection("users")
          .doc(user!.uid)
          .update({"bin": binCode});
      userModel!.bin = binCode;

      timer = Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      });
    }
  }
}
