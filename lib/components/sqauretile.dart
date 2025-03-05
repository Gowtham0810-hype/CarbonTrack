import 'package:flutter/material.dart';

class Sqauretile extends StatelessWidget {
  final String imagepath;
  const Sqauretile({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1),
            )
          ]),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(25),
      child: Image.asset(
        imagepath,
        height: 50,
        width: 50,
      ),
    );
  }
}
