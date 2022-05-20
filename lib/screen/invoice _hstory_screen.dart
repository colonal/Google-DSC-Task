// ignore_for_file: file_names

import 'package:dsc_task/user.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';
import '../widget/charts_widget.dart';
import '../model/user_model.dart';

class InvoicesHistoryScreen extends StatefulWidget {
  const InvoicesHistoryScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesHistoryScreen> createState() => _InvoicesHistoryScreenState();
}

class _InvoicesHistoryScreenState extends State<InvoicesHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    )),
                const SizedBox(height: 50),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: SimpleTimeSeriesChart.withSampleData(),
                ),
                const SizedBox(height: 50),
                invoices!.isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          "There are no invoices",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: invoices!.length,
                        separatorBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                  color: Colors.grey.withOpacity(0.7),
                                  height: 2),
                            ),
                        itemBuilder: (context, index) {
                          return newMethod(
                              invoices![invoices!.length - 1 - index]);
                        })
              ],
            ),
          ),
        )),
      ),
    );
  }

  ListTile newMethod(Invoice invoice) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.money! + "\$",
            style: TextStyle(
              color: invoice.state! == "Send"
                  ? Colors.redAccent.withOpacity(1)
                  : Colors.greenAccent.withOpacity(1),
              fontSize: 18,
            ),
          ),
          Text(
            invoice.name!,
            style: TextStyle(
              color: Colors.white.withOpacity(1),
              fontSize: 15,
            ),
          ),
        ],
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            invoice.name!.split(" ")[0][0],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black.withOpacity(.9),
              fontSize: 20,
            ),
          ),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.date!.split(" ")[0],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white.withOpacity(.7),
              fontSize: 15,
            ),
          ),
          Text(
            invoice.date!.split(" ")[1],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white.withOpacity(.7),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
