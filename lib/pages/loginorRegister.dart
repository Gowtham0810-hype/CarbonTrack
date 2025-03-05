import 'package:flutter/material.dart';
import 'package:portal/pages/loginpage.dart';
import 'package:portal/pages/registerpage.dart';

class Loginorregister extends StatefulWidget {
  const Loginorregister({super.key});

  @override
  State<Loginorregister> createState() => _LoginorregisterState();
}

class _LoginorregisterState extends State<Loginorregister> {
  bool showloginpage = true;
  void togglepage() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return Loginpage(ontap: togglepage);
    } else {
      return Registerpage(
        ontap: togglepage,
      );
    }
  }
}
