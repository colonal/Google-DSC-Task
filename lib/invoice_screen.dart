import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

import 'background_widget.dart';

class InvoiceScreen extends StatefulWidget {
  final Invoice invoice;
  const InvoiceScreen({required this.invoice, Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/success.gif",
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Success send to: ${widget.invoice.name}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Amount: ${widget.invoice.money!.substring(1, widget.invoice.money!.length)}\$",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Date: ${widget.invoice.date}",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Card Number: " +
                          formatcardKeyShow("${widget.invoice.cardKey}"),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 20),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800]!.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Dashboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatcardKeyShow(String number) {
    String newKey = '';
    for (int i = 0; i < number.length; ++i) {
      newKey += (i % 4 == 0 && i != 0) ? "\t${number[i]}" : number[i];
    }

    return newKey;
  }
}
