// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:portal/pages/additem.dart';
import 'package:portal/utils/item.dart';

class Catitem extends StatelessWidget {
  final Item item;
  final Icon icon;
  const Catitem({required this.item, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: icon,
          title: Text(item.name),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            // Navigate to SecondPage and pass the values
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Additem(
                        item_: item,
                      )),
            );
          },
        ));
  }
}
