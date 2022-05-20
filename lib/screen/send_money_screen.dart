import 'package:cloud_firestore/cloud_firestore.dart';
import 'invoice_screen.dart';
import '../user.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';
import '../widget/build_text_field_widget.dart';
import '../widget/button_widget.dart';

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
      body: BackgroundWidget(
        child: SafeArea(
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
                  formatcardKeyShow(userModel!.cardKey!),
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
                  formatcardKeyShow(widget.frind.cardKey!),
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
                buttonWidget(
                    text: "Send",
                    isLoding: isLoding,
                    onTap: () {
                      _send();
                    }),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _send() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoding = !isLoding;
      });
      try {
        final _firestore = FirebaseFirestore.instance;

        final data =
            await _firestore.collection("users").doc(widget.frind.uid).get();
        if (data["block"]) {
          SnackBar snackBar = SnackBar(
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              content: const Text(
                "Error Send, Card  Friend  Block ",
                textAlign: TextAlign.center,
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            isLoding = !isLoding;
          });
          return;
        }
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
          "cardKey": widget.frind.cardKey,
          "state": "Send",
        });
        // invoice!.add(myInvoice);
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
          "cardKey": userModel!.cardKey,
          "state": "Recepion"
        });
        await _firestore
            .collection("users")
            .doc(widget.frind.uid)
            .collection("invoice")
            .doc()
            .set(frindInvoice.toMap());

        userModel!.money = my;
        invoices!.add(myInvoice);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => InvoiceScreen(invoice: myInvoice)));
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

  String formatcardKeyShow(String number) {
    String newKey = '';
    for (int i = 0; i < number.length; ++i) {
      newKey += (i % 4 == 0 && i != 0) ? "\t${number[i]}" : number[i];
    }

    return newKey;
  }
}
