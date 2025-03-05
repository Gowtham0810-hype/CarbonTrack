// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hinttxt;
  final bool obscuretext;
  const Mytextfield(
      {super.key,
      required this.controller,
      required this.hinttxt,
      required this.obscuretext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 0, top: 10),
      child: TextField(
          obscureText: obscuretext,
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700)),
              fillColor: Colors.grey[200],
              filled: true,
              hintText: hinttxt,
              hintStyle: TextStyle(color: Colors.grey[500]))),
    );
  }
}
