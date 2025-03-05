// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portal/utils/cat.dart';
import 'package:portal/utils/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

EmType emt1 =
    EmType(name: 'Purchase', metrics: 'Quantity', measurement: 'item(s)');

EmType emt2 =
    EmType(name: 'Transport', metrics: 'Distance', measurement: 'km(s)');

EmType emt3 = EmType(name: 'Meal', metrics: 'Quantity', measurement: 'meal(s)');

EmType emt4 =
    EmType(name: 'Streaming', metrics: 'Duration', measurement: 'hour(s)');

EmType emt5 =
    EmType(name: 'Fashion', metrics: 'Quantity', measurement: 'item(s)');

EmType emt6 = EmType(name: 'Food', metrics: 'Quantity', measurement: 'g');

List<Item> it1 = [
  Item(
    name: 'SmartPhone',
    emission: 80,
    emType: emt1,
  ),
  Item(
    name: 'Laptop',
    emission: 210,
    emType: emt1,
  ),
  Item(
    name: 'Tablet',
    emission: 87,
    emType: emt1,
  ),
  Item(
    name: 'Computer',
    emission: 588,
    emType: emt1,
  ),
  Item(
    name: 'Television',
    emission: 500,
    emType: emt1,
  ),
  Item(
    name: 'Electric Car',
    emission: 8800,
    emType: emt1,
  ),
  Item(
    name: 'Hybrid Car',
    emission: 6500,
    emType: emt1,
  ),
  Item(
    name: 'Cyrpto Transaction',
    emission: 20,
    emType: emt1,
  ),
  Item(
    name: 'NFT',
    emission: 211,
    emType: emt1,
  )
];
List<Item> it2 = [
  Item(
    name: "Train",
    emission: 0.084,
    emType: emt2,
  ),
  Item(
    name: 'Car',
    emission: 38.55,
    emType: emt2,
  ),
  Item(
    name: 'Bus',
    emission: 15.45,
    emType: emt2,
  ),
  Item(
    name: 'Plane',
    emission: 453.77,
    emType: emt2,
  ),
  Item(
    name: 'Boat',
    emission: 120.45,
    emType: emt2,
  ),
  Item(
    name: 'MotorBike',
    emission: 16.2,
    emType: emt2,
  ),
];
List<Item> it3 = [
  Item(
    name: 'High Meat',
    emission: 2.16,
    emType: emt3,
  ),
  Item(
    name: 'Medium Meat',
    emission: 1.69,
    emType: emt3,
  ),
  Item(
    name: 'Low Meat',
    emission: 1.4,
    emType: emt3,
  ),
  Item(
    name: 'Pescetarian',
    emission: 1.17,
    emType: emt3,
  ),
  Item(
    name: 'Vegetarian',
    emission: 1.14,
    emType: emt3,
  ),
  Item(
    name: 'Vegan',
    emission: 0.867,
    emType: emt3,
  ),
];
List<Item> it4 = [
  Item(
    name: 'Coat',
    emission: 51,
    emType: emt5,
  ),
  Item(
    name: 'Dress',
    emission: 54.33,
    emType: emt5,
  ),
  Item(
    name: 'Jeans',
    emission: 25,
    emType: emt5,
  ),
  Item(
    name: 'Shirt',
    emission: 12.5,
    emType: emt5,
  ),
  Item(
    name: 'Shoes',
    emission: 18,
    emType: emt5,
  ),
  Item(
    name: 'Sweater',
    emission: 30.6,
    emType: emt5,
  ),
  Item(
    name: 'T-Shirt',
    emission: 7.67,
    emType: emt5,
  ),
];

List<Item> it5 = [
  Item(
    name: 'Meat',
    emission: 3.5,
    emType: emt6,
  ),
  Item(
    name: 'Coffee',
    emission: 0.628,
    emType: emt6,
  ),
  Item(
    name: 'Chocolate',
    emission: 0.974,
    emType: emt6,
  ),
  Item(
    name: 'Fish',
    emission: 1.22,
    emType: emt6,
  ),
  Item(
    name: 'Chicken',
    emission: 1.38,
    emType: emt6,
  ),
  Item(
    name: 'Eggs',
    emission: 0.96,
    emType: emt6,
  ),
  Item(
    name: 'Potatoes',
    emission: 0.58,
    emType: emt6,
  ),
  Item(
    name: 'Rice',
    emission: 0.54,
    emType: emt6,
  ),
  Item(
    name: 'Nuts',
    emission: 0.46,
    emType: emt6,
  ),
  Item(
    name: 'Vegetables',
    emission: 0.4,
    emType: emt6,
  ),
  Item(
    name: 'Milk',
    emission: 0.38,
    emType: emt6,
  ),
  Item(
    name: 'Fruits',
    emission: 0.22,
    emType: emt6,
  ),
];
List<Item> it6 = [
  Item(
    name: 'Audio-MP3',
    emission: 0.033,
    emType: emt4,
  ),
  Item(
    name: 'Video-HD',
    emission: 0.04,
    emType: emt4,
  ),
  Item(
    name: 'Video-Full HD/1080p',
    emission: 0.135,
    emType: emt4,
  ),
  Item(
    name: 'Video-UltraHD/4k',
    emission: 0.600,
    emType: emt4,
  ),
];

class ItemWithQuantity {
  final Item item;
  final double quantity;

  ItemWithQuantity(this.item, this.quantity);

  // Convert ItemWithQuantity to a Map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'item': {
        'name': item.name,
        'emission': item.emission,
        'emType': {
          'name': item.emType.name,
          'metrics': item.emType.metrics,
          'measurement': item.emType.measurement,
        },
      },
      'quantity': quantity,
    };
  }

  // Convert Map back to ItemWithQuantity for JSON decoding
  static ItemWithQuantity fromMap(Map<String, dynamic> map) {
    return ItemWithQuantity(
      Item(
        name: map['item']['name'],
        emission: map['item']['emission'],
        emType: EmType(
          name: map['item']['emType']['name'],
          metrics: map['item']['emType']['metrics'],
          measurement: map['item']['emType']['measurement'],
        ),
      ),
      map['quantity'],
    );
  }
}

class CategoriesList extends ChangeNotifier {
  final List<Cat> categ = [
    Cat(name: 'Electronics', icon: Icon(Icons.devices), items: it1),
    Cat(name: 'Travel', icon: Icon(Icons.flight), items: it2),
    Cat(name: 'Meal', icon: Icon(Icons.food_bank), items: it3),
    Cat(name: 'Fashion', icon: Icon(Icons.checkroom), items: it4),
    Cat(name: 'Streaming', icon: Icon(Icons.computer), items: it6),
    Cat(name: 'Food', icon: Icon(Icons.shopping_cart), items: it5),
    Cat(name: 'Custom', icon: Icon(Icons.build), items: it1),
  ];

  List<ItemWithQuantity> usercart = [];

  CategoriesList() {
    loadCart();
  }

  List<ItemWithQuantity> getcat() {
    return usercart;
  }

  // Add item to cart and save to shared preferences
  void addtoCart(ItemWithQuantity itq) {
    usercart.add(itq);
    saveCart();
    notifyListeners();
  }

  // Remove item from cart and save to shared preferences
  void removefrCart(ItemWithQuantity itq) {
    usercart.remove(itq);
    saveCart();
    notifyListeners();
  }

  // Save the user cart to shared preferences
  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartData =
        usercart.map((itq) => jsonEncode(itq.toMap())).toList();
    await prefs.setStringList('usercart', cartData);
  }

  // Load the user cart from shared preferences
  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartData = prefs.getStringList('usercart');
    if (cartData != null) {
      usercart = cartData
          .map((data) => ItemWithQuantity.fromMap(jsonDecode(data)))
          .toList();
      notifyListeners();
    }
  }

  // Return list of categories
  List<Cat> getcart() {
    return categ;
  }
}
