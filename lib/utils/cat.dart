import 'package:flutter/material.dart';
import 'package:portal/utils/item.dart';

class Cat {
  final String name;
  final Icon icon;
  final List<Item> items;
  Cat({
    required this.name,
    required this.icon,
    required this.items,
  });
}
