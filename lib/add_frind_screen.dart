import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_task/user.dart';
import 'package:dsc_task/user_model.dart';
import 'package:flutter/material.dart';

class AddFrindScreen extends StatefulWidget {
  const AddFrindScreen({Key? key}) : super(key: key);

  @override
  State<AddFrindScreen> createState() => _AddFrindScreenState();
}

class _AddFrindScreenState extends State<AddFrindScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  bool isLoding = false;
  bool error = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_outlined,
                              color: Colors.white.withOpacity(0.6)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          "Add Frind",
                          style: TextStyle(
                            color: Colors.white.withOpacity(1),
                            fontSize: 18,
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    const SizedBox(height: 40),
                    buildTextField(
                      controller: nameController,
                      text: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[50],
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{4,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 4 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nameController.text = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      controller: emailController,
                      text: "Email Address",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }

                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController.text =
                            value!; // GETTING the value of edit text
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      controller: keyController,
                      text: 'Card Number',
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Card Number");
                        }

                        if (!RegExp(r"[0-9].{14,14}$").hasMatch(value)) {
                          return ("Please Enter a valid Number");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        keyController.text =
                            value!; // GETTING the value of edit text
                      },
                    ),
                    if (error) const SizedBox(height: 10),
                    if (error)
                      Text(
                        "There is no account for this data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.redAccent[200],
                          fontSize: 15,
                        ),
                      ),
                    const SizedBox(height: 60),
                    InkWell(
                      onTap: () {
                        add();
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
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Add",
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
            ),
          ))
        ],
      ),
    );
  }

  Padding buildTextField(
      {TextEditingController? controller,
      String? text,
      Widget? prefixIcon,
      bool isPass = false,
      TextInputType? keyboardType,
      String? Function(String?)? validator,
      Function(String?)? onSaved}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            prefixIconColor: Colors.grey[50],
            labelText: text,
            labelStyle: TextStyle(color: Colors.grey[50]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.6), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
          ),
          obscureText: isPass,
          validator: validator,
          onSaved: onSaved),
    );
  }

  void add() async {
    setState(() {
      isLoding = !isLoding;
      error = false;
    });
    final _firestore = FirebaseFirestore.instance;
    // await get.collection("users").doc(userModel!.uid).collection("frind").doc("").set({});
    await _firestore
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .where('cardKey', isEqualTo: keyController.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach(
          ((element) async {
            print("element: ${element["uid"]}");
            element["uid"];
            Frinds frind = Frinds.fromMap(element, name: nameController.text);
            await _firestore
                .collection("users")
                .doc(userModel!.uid)
                .collection("frind")
                .doc(frind.uid)
                .set(frind.toMap());
            frinds!.add(frind);
          }),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          error = true;
        });
      }
    });

    setState(() {
      isLoding = !isLoding;
    });
  }
}
