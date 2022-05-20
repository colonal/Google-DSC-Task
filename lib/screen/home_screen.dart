import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_frind_screen.dart';
import 'auth_bin_screen.dart';
import 'invoice%20_hstory_screen.dart';
import 'otp_screen.dart';
import 'profile_screen.dart';
import 'see_all_screen.dart';
import '../user.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoding = false;
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    setState(() {
      isLoding = !isLoding;
    });
    _gitFrinds().then((value) => _gitInvoice().then((value) => setState(() {
          isLoding = !isLoding;
        })));
    _gitInvoice();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.black,
          onRefresh: () async {
            onRefresh();
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
                            await Navigator.of(context).push(MaterialPageRoute(
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
                                  fontSize: 20,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$ ${userModel!.money!}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontSize: 30,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  userModel!.endDate!,
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
                                color: Colors.black.withOpacity(.8),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Send MoneyTo",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 18,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => const SeeAllScreen()))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Text(
                          "see all",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
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
                            setState(() {
                              isLoding = !isLoding;
                            });
                            _gitFrinds().then((value) => setState(() {
                                  isLoding = !isLoding;
                                }));
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
                      "Log out",
                      style: TextStyle(
                        color: Colors.redAccent.withOpacity(1),
                        fontSize: 15,
                      ),
                    ),
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      frinds!.clear();
                      invoices!.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const LoginScreen()));
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                ],
              ),
            ),
          ),
        )),
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
    int color = int.parse("0xFF${frind.cardKey!.substring(0, 6)}");
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
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white,
                  Color(color).withOpacity(0.5),
                ],
              ),
            ),
            child: Center(
              child: Text(
                frind.name!.split(" ")[0][0],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(1),
                  fontWeight: FontWeight.bold,
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

  void onRefresh() async {
    setState(() {
      isLoding = !isLoding;
    });
    await _getData();
    await _gitFrinds();
    await _gitInvoice();
    setState(() {
      isLoding = !isLoding;
    });
  }

  Future<void> _getData() async {
    userModel = UserModel.fromMap(
        await _firestore.collection("users").doc(userModel!.uid).get());
  }

  Future<void> _gitFrinds() async {
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
  }

  Future<void> _gitInvoice() async {
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
  }
}
