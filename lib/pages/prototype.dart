// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/pages/categorytosubcategory.dart';
import 'package:portal/pages/scannerpage.dart';
import 'package:portal/utils/cat.dart';
import 'package:provider/provider.dart';

class Prototype extends StatefulWidget {
  const Prototype({super.key});

  @override
  State<Prototype> createState() => _PrototypeState();
}

class _PrototypeState extends State<Prototype> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesList>(
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Emissions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.getcart().length,
              itemBuilder: (context, index) {
                Cat categ = value.getcart()[index];
                return Categorytosubcategory(category: categ);
              },
            ),
            // Add the button that looks like Categorytosubcategory
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScannerPage(), // Ensure this page is imported
                  ),
                );
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width:
                      400.0, // Match the width of Categorytosubcategory items
                  height: 100.0, // Match the height
                  child: Center(
                    child: Text(
                      "Scanner",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
