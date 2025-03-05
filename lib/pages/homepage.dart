// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:portal/pages/EmissionList.dart';

import 'package:portal/pages/airecom.dart';
import 'package:portal/pages/noteadd.dart';
import 'package:portal/pages/prototype.dart';

import 'package:portal/pages/scannerpage.dart';
import 'package:portal/utils/mybottomnav.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedindex = 0;
  void navigatebar(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  final List<Widget> pages = [
    Emissionlist(),
    Prototype(),
    NotesPage(),
    Airecom()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Mybottomnav(
        ontabc: (index) => navigatebar(index),
      ),
      body: pages[selectedindex],
    );
  }
}
