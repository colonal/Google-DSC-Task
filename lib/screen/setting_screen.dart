import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/background_widget.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ProfailScreen()));
                  },
                ),
                ListTile(
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
