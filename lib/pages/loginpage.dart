// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:portal/components/mybuton.dart';
import 'package:portal/components/mytextfield.dart';
import 'package:portal/components/sqauretile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatefulWidget {
  final Function()? ontap;
  const Loginpage({super.key, required this.ontap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final usercntrl = TextEditingController();
  final passcntrl = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usercntrl.text, password: passcntrl.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //wrong mail
      if (e.code == 'invalid-email') {
        wrong("invalid email !");
      }
      //wrong password
      else if (e.code == 'invalid-credential') {
        wrong("invalid password !");
      }
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
                  height: 50,
                ),

                Image.asset(
                  'lib/images/logo.png',
                  height: 180,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome back ,You have been missed!",
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

                Padding(
                  padding: const EdgeInsets.only(left: 240, top: 10),
                  child: Text("forgot password?",
                      style: TextStyle(color: Colors.grey[600])),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                Mybuton(
                  onTap: signIn,
                  disp: "Sign In",
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
                    Text("Not a member?"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: widget.ontap,
                        child: Text(
                          "Registor now",
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
