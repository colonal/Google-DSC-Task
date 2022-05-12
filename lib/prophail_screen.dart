import 'dart:async';

import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

class ProfailScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfailScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  State<ProfailScreen> createState() => _ProfailScreenState();
}

class _ProfailScreenState extends State<ProfailScreen> {
  bool show = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        show = !show;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white.withOpacity(0.8),
                    )),
              ),
              const SizedBox(height: 20),
              Hero(
                tag: widget.userModel.cardKey!,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ])),
                  child: !show
                      ? Container()
                      : Center(
                          child: Text(
                            widget.userModel.name!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white.withOpacity(.9),
                              fontSize: 30,
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ))
      ]),
    );
  }
}
