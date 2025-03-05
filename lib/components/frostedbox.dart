import 'package:flutter/material.dart';

class Frostedbox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const Frostedbox({
    required this.width,
    required this.height,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.green[300], // Background color
        borderRadius: BorderRadius.circular(5), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 4),
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), // Clip corners
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the box
          child: child,
        ),
      ),
    );
  }
}
