// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/utils/cat.dart';
import 'package:portal/utils/catitem.dart';
import 'package:provider/provider.dart';

class Addemission extends StatelessWidget {
  const Addemission({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesList>(
      builder: (context, value, child) => Column(
        children: [
          SizedBox(
            height: 40,
          ),
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
          Expanded(
              child: ListView.builder(
                  itemCount: value.getcart().length,
                  itemBuilder: (context, index) {
                    Cat categ = value.getcart()[index];
                    return Catitem(
                      item: categ.items[0],
                      icon: categ.icon,
                    );
                  }))
        ],
      ),
    );
  }
}
