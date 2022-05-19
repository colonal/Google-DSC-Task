import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/background_widget.dart';
import '../user.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';

import 'auth_bin_screen.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({Key? key}) : super(key: key);

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  bool isLoging = false;
  int indexSelect = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: (Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white.withOpacity(0.9),
                            ))),
                        const Text(
                          "Frinds",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: ListView.separated(
                          itemCount: frinds!.length,
                          separatorBuilder: (_, __) => SizedBox(
                                height: 30,
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.7),
                                    height: 2),
                              ),
                          itemBuilder: (_, index) =>
                              _buildFrind(frinds![index], index)),
                    ),
                  ],
                ))),
      ),
    );
  }

  _buildFrind(Frinds frind, int index) {
    int color = int.parse("0xFF${frind.cardKey!.substring(0, 6)}");
    return ListTile(
      leading: Container(
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
      title: Text(
        frind.name!,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      trailing: IconButton(
        onPressed: () async {
          setState(() {
            isLoging = !isLoging;
            indexSelect = index;
          });
          final _firestore = FirebaseFirestore.instance;
          await _firestore
              .collection("users")
              .doc(userModel!.uid)
              .collection("frind")
              .doc(frind.uid)
              .delete()
              .then((value) => frinds!.remove(frind))
              .catchError((_) {
            SnackBar snackBar = SnackBar(
                backgroundColor: Colors.red.withOpacity(0.8),
                content: const Text(
                  "Unexpected Error",
                  textAlign: TextAlign.center,
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });

          setState(() {
            isLoging = !isLoging;
            indexSelect = -1;
          });
        },
        icon: isLoging && (indexSelect == index)
            ? const CircularProgressIndicator.adaptive()
            : Icon(
                Icons.delete_outlined,
                color: Colors.redAccent.withOpacity(0.8),
              ),
      ),
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
    );
  }
}
