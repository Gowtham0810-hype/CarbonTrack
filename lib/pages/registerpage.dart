// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:portal/components/mybuton.dart';
import 'package:portal/components/mytextfield.dart';
import 'package:portal/components/sqauretile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registerpage extends StatefulWidget {
  final Function()? ontap;
  const Registerpage({super.key, required this.ontap});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final usercntrl = TextEditingController();
  final passcntrl = TextEditingController();
  final confcntrl = TextEditingController();

  void signup() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
    );
    if (passcntrl.text != confcntrl.text) {
      Navigator.pop(context);
      wrong("Passwords do not match");
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usercntrl.text, password: passcntrl.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrong(e.code);
      // TODO
    }
  }

  void wrong(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.lock,
                  size: 120,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "create your account now",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 15,
                ),
                Mytextfield(
                    controller: usercntrl,
                    hinttxt: "Email",
                    obscuretext: false),
                Mytextfield(
                    controller: passcntrl,
                    hinttxt: "Password",
                    obscuretext: true),
                Mytextfield(
                    controller: confcntrl,
                    hinttxt: "Confirm Password",
                    obscuretext: true),

                // SizedBox(
                //   height: 20,
                // ),
                Mybuton(
                  onTap: signup,
                  disp: "Sign Up",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            Divider(thickness: 1, color: Colors.grey.shade900),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text("or continue with"),
                      ),
                      Expanded(
                        child:
                            Divider(thickness: 1, color: Colors.grey.shade900),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Sqauretile(imagepath: 'lib/images/g.png'),
                    Sqauretile(imagepath: 'lib/images/a.png'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: widget.ontap,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
                // ElevatedButton(onPressed: () {}, child: Text("Sign In"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
