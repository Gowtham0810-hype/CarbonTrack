// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/utils/item.dart';
import 'package:provider/provider.dart';

class Additem extends StatefulWidget {
  final Item item_;
  const Additem({required this.item_, super.key});

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  double _sliderValue = 1.0;
  double _emission = 0.0; // Initialize _emission to 0.0

  @override
  void initState() {
    super.initState();
    _emission = widget.item_.emission; // Initialize _emission here
  }

  void addItemtocart(ItemWithQuantity itq) {
    Provider.of<CategoriesList>(context, listen: false).addtoCart(itq);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("succesfully added"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add Emission",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.item_.emType.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 10),
            Text(widget.item_.name, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text(widget.item_.emType.metrics,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: 10),
            Text(
                "${_sliderValue.toInt()}" " " + widget.item_.emType.measurement,
                style: TextStyle(fontSize: 20)),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                min: 1.0, // Set the minimum value to 1
                max: 10.0, // Maximum value
                divisions: 9, // Snap to integers from 1 to 10
                value: _sliderValue,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                    _emission = value *
                        widget.item_
                            .emission; // Calculate the emission based on the slider value
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text("Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: 10),
            Text("${_emission.toStringAsFixed(2)} KgCO2eq",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addItemtocart(ItemWithQuantity(widget.item_, _emission));
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                      Colors.green), // Fixed ButtonStyle
                ),
                child: Text("Add Emission"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to FirstPage
              },
              child: Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
