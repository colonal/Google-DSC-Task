import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

import 'build_text_field_widget.dart';

class SendMoneyScreen extends StatefulWidget {
  final Frinds frind;
  const SendMoneyScreen({required this.frind, Key? key}) : super(key: key);

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController moneyController = TextEditingController();
  bool isLoding = false;
  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.white.withOpacity(0.6)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "Send Money",
                        style: TextStyle(
                          color: Colors.white.withOpacity(1),
                          fontSize: 18,
                        ),
                      ),
                      Container(),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "My Acount",
                    style: TextStyle(
                      color: Colors.white.withOpacity(1),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userModel!.cardKey!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Available Balance",
                    style: TextStyle(
                      color: Colors.white.withOpacity(1),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${userModel!.money!}\$",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Send To",
                    style: TextStyle(
                      color: Colors.white.withOpacity(1),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.frind.name!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Card",
                    style: TextStyle(
                      color: Colors.white.withOpacity(1),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.frind.cardKey!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: buildTextField(
                      text: "Amount",
                      controller: moneyController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your amount");
                        }

                        if (double.parse(value) > (userModel!.money ?? 0)) {
                          return ("Please Enter a valid amount");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        moneyController.text =
                            value!; // GETTING the value of edit text
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      _send();
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
                            ? const CircularProgressIndicator.adaptive()
                            : Text(
                                "Send",
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
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  void _send() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoding = !isLoding;
      });
      print(moneyController.text);
      try {
        final _firestore = FirebaseFirestore.instance;
        final data =
            await _firestore.collection("users").doc(widget.frind.uid).get();
        double my = userModel!.money! - double.parse(moneyController.text);
        double frind = data["money"] + double.parse(moneyController.text);

        await _firestore.collection("users").doc(userModel!.uid).update({
          "money": my,
        });
        await _firestore.collection("users").doc(widget.frind.uid).update({
          "money": frind,
        });
        DateTime now = DateTime.now();
        String date =
            "${now.month}/${now.day}/${now.year} ${now.hour}:${now.minute}";
        final myInvoice = Invoice.fromMap({
          "uid": widget.frind.uid,
          "name": widget.frind.name,
          "date": date,
          "money": "-${moneyController.text}",
          "state": "Send",
        });
        await _firestore
            .collection("users")
            .doc(userModel!.uid)
            .collection("invoice")
            .doc()
            .set(myInvoice.toMap());

        final frindInvoice = Invoice.fromMap({
          "uid": userModel!.uid,
          "name": userModel!.name,
          "date": date,
          "money": "+${moneyController.text}",
          "state": "Recepion"
        });
        await _firestore
            .collection("users")
            .doc(widget.frind.uid)
            .collection("invoice")
            .doc()
            .set(frindInvoice.toMap());

        userModel!.money = my;
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.greenAccent.withOpacity(0.8),
            content: const Text(
              "Done Send",
              textAlign: TextAlign.center,
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } catch (_) {
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            content: const Text(
              "Error Send",
              textAlign: TextAlign.center,
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        isLoding = !isLoding;
      });
    }
  }
}
