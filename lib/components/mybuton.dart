// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Mybuton extends StatelessWidget {
  final String disp;
  final Function()? onTap;
  const Mybuton({super.key, required this.onTap, required this.disp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            disp,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
