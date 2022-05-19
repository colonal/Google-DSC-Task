import 'package:flutter/material.dart';

Padding buildTextField(
    {TextEditingController? controller,
    String? text,
    Widget? prefixIcon,
    bool isPass = false,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
    Function(String?)? onSaved}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        enabled: enabled,
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
