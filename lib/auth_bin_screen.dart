import 'dart:async';

import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

import 'add_frind_screen.dart';
import 'send_money_screen.dart';

class AuthBinScreen extends StatefulWidget {
  final Frinds frind;
  const AuthBinScreen({required this.frind, Key? key}) : super(key: key);

  @override
  State<AuthBinScreen> createState() => _AuthBinScreenState();
}

class _AuthBinScreenState extends State<AuthBinScreen>
    with SingleTickerProviderStateMixin {
  String binCode = "";
  bool isError = false;
  bool isAnimation = false;
  late Animation<AlignmentGeometry> _animation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween<AlignmentGeometry>(
            begin: Alignment.centerRight, end: Alignment.centerLeft)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      "Bin Number Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  isAnimation
                      ? SizedBox(
                          width: double.infinity,
                          child: AlignTransition(
                            alignment: _animation,
                            child: newMethod(context),
                          ),
                        )
                      : newMethod(context),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _number("1"),
                          _number("2"),
                          _number("3"),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _number("4"),
                          _number("5"),
                          _number("6"),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _number("7"),
                          _number("8"),
                          _number("9"),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              _number("0"),
                              Container(),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                if (binCode.isNotEmpty) {
                                  binCode =
                                      binCode.substring(0, binCode.length - 1);
                                  isError = false;
                                  setState(() {});
                                }
                              },
                              icon: Icon(Icons.backspace_outlined,
                                  color: Colors.white.withOpacity(0.8)))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox newMethod(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _inputbin(binCode.isNotEmpty),
          _inputbin(binCode.length >= 2),
          _inputbin(binCode.length >= 3),
          _inputbin(binCode.length >= 4),
        ],
      ),
    );
  }

  Widget _number(String text) {
    return MaterialButton(
      onPressed: () {
        if (binCode.length < 4) {
          binCode += text;

          if (binCode.length == 4) {
            if (userModel!.bin != binCode) {
              isError = true;
              runAnimation();
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SendMoneyScreen(frind: widget.frind),
              ));
            }
          }
          setState(() {});
        }
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _inputbin(bool show) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: isError ? Colors.redAccent : Colors.white, width: 1),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.2),
        radius: 30,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              show ? "*" : "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void runAnimation() {
    setState(() {
      isAnimation = !isAnimation;
    });
    _controller.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _controller.stop();
      setState(() {
        isAnimation = !isAnimation;
      });
    });
  }
}
