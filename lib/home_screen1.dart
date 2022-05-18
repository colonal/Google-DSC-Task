import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/add_frind_screen.dart';
import 'package:dsc_task/auth_bin_screen.dart';
import 'package:dsc_task/invoice%20_hstory_screen.dart';
import 'package:dsc_task/otp_screen.dart';
import 'package:dsc_task/profile_screen.dart';
import 'package:dsc_task/send_money_screen.dart';
import 'package:dsc_task/setting_screen.dart';
import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen1 extends StatefulWidget {
  // UserModel userModel;
  const HomeScreen1({Key? key}) : super(key: key);

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  bool isLoding = false;
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    _gitFrinds();
    _gitInvoice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("frinds!.length: ${frinds!.length}");
    return Scaffold(
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
              child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.black,
            onRefresh: () async {
              print("onRefresh");

              _gitFrinds();
              // setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${userModel!.name!.split(" ")[0]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.9),
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Manage Your Money",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.6),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag: userModel!.cardKey!,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const ProfailScreen()));
                            },
                            child: CircleAvatar(
                              maxRadius: 30,
                              child: Text(
                                userModel!.name![0],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.9),
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      height: 160,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          tileMode: TileMode.decal,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(1),
                            Colors.blue[100]!,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  userModel!.name!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (userModel!.block!)
                                    Icon(
                                      Icons.block,
                                      color: Colors.redAccent[400],
                                    ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "USD",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userModel!.endDate!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.7),
                                      fontSize: 18,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  Text(
                                    "${userModel!.money!}\$",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.7),
                                      fontSize: 18,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatcardKeyShow(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 2,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Send MoneyTo",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white.withOpacity(1),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (_) => const AddFrindScreen(),
                            ))
                                .then((value) {
                              _gitFrinds();
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Color.fromARGB(255, 49, 20, 47),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 80,
                          child: isLoding
                              ? const Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    height: 40,
                                    child: CircularProgressIndicator(
                                        color: Colors.grey),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: frinds!.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, index) =>
                                      _buildFrind(frinds![index])),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "Card Setting",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white.withOpacity(1),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        "Change Pincode",
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 15,
                        ),
                      ),
                      leading: const Icon(Icons.password_outlined,
                          color: Colors.white),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined,
                          color: Colors.white),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const OTPScreen(
                                  isUpdate: true,
                                )));
                      },
                    ),
                    Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                    ListTile(
                      title: Text(
                        "Invoices History",
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 15,
                        ),
                      ),
                      leading: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined,
                          color: Colors.white),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const InvoicesHistoryScreen()));
                      },
                    ),
                    Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                    ListTile(
                      title: Text(
                        "Block Card",
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 15,
                        ),
                      ),
                      leading: const Icon(Icons.block, color: Colors.white),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined,
                          color: Colors.white),
                      onTap: () {
                        _displayDialog(context);
                      },
                    ),
                    Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                    ListTile(
                      title: Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 15,
                        ),
                      ),
                      leading: const Icon(Icons.settings, color: Colors.white),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined,
                          color: Colors.white),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SettingScreen()));
                      },
                    ),
                    Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  String formatcardKeyShow() {
    List l = userModel!.cardKey!.split("");
    String newKey = '';
    for (int i = 0; i < l.length; ++i) {
      newKey += (i % 4 == 0 && i != 0) ? "\t${l[i]}" : l[i];
    }

    return newKey;
  }

  _displayDialog(BuildContext context) async {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(false),
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () => Navigator.of(context).pop(true),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Block"),
      content: const Text("Are you sure that the bank card is blocked ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    bool? isBlock = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    if (isBlock!) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection("users")
          .doc(userModel!.uid)
          .update({"block": !userModel!.block!});
      userModel!.block = !userModel!.block!;
      setState(() {});
    }
  }

  _buildFrind(Frinds frind) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (_) =>
              AuthBinScreen(frind: frind), // SendMoneyScreen(frind: frind),
        ))
            .then((value) {
          setState(() {});
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                frind.name!.split(" ")[0][0],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(.9),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              frind.name!.split(" ")[0],
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white.withOpacity(.9),
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getData() async {
    userModel = UserModel.fromMap(
        await _firestore.collection("users").doc(userModel!.uid).get());
  }

  void _gitFrinds() async {
    setState(() {
      isLoding = !isLoding;
    });

    userModel = UserModel.fromMap(
        await _firestore.collection("users").doc(userModel!.uid).get());

    await _firestore
        .collection("users")
        .doc(userModel!.uid)
        .collection("frind")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        frinds?.clear();
        value.docs.forEach(((element) async {
          frinds!.add(Frinds.fromMap(element));
        }));
      }
    });
    await _firestore
        .collection("users")
        .doc(userModel!.uid)
        .collection("invoice")
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        invoices?.clear();
        value.docs.forEach(((element) async {
          invoices!.add(Invoice.fromMap(element));
        }));
      }
    });
    setState(() {
      isLoding = !isLoding;
    });
  }

  void _gitInvoice() async {}
}
