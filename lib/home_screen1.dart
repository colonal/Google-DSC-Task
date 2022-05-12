import 'package:dsc_task/prophail_screen.dart';
import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

class HomeScreen1 extends StatefulWidget {
  final UserModel userModel;
  const HomeScreen1({required this.userModel, Key? key}) : super(key: key);

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
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
              padding: const EdgeInsets.all(10.0),
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
                            "Hello Rakib",
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
                        tag: widget.userModel.cardKey!,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProfailScreen(
                                    userModel: widget.userModel)));
                          },
                          child: CircleAvatar(
                            maxRadius: 30,
                            child: Text(
                              widget.userModel.name![0],
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
                            Text(
                              widget.userModel.name!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black.withOpacity(.9),
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                            ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.userModel.endDate!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.7),
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  "${widget.userModel.money!}\$",
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
                    children: [
                      Container(
                        width: 50,
                        height: 50,
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
                    onTap: () {},
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
                    onTap: () {},
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
                    onTap: () {},
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7), height: 2),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  String formatcardKeyShow() {
    List l = widget.userModel.cardKey!.split("");
    String newKey = '';
    for (int i = 0; i < l.length; ++i) {
      newKey += (i % 4 == 0 && i != 0) ? "\t${l[i]}" : l[i];
    }

    return newKey;
  }
}
