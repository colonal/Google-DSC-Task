import 'package:flutter/material.dart';

Widget buttonWidget(
    {required void Function()? onTap,
    required String text,
    bool isLoding = false}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: isLoding
            ? const CircularProgressIndicator.adaptive()
            : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[200]!,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
      ),
    ),
  );
}
