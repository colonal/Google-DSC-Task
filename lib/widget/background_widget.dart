import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        child,
      ],
    );
  }
}
