import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/utils/item.dart';
import 'package:provider/provider.dart';

class Emissioncart extends StatefulWidget {
  final ItemWithQuantity itq;

  const Emissioncart({required this.itq, super.key});

  @override
  State<Emissioncart> createState() => _EmissioncartState();
}

class _EmissioncartState extends State<Emissioncart> {
  void removefromcart(ItemWithQuantity itq) {
    Provider.of<CategoriesList>(context, listen: false).removefrCart(itq);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.green[300], borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            widget.itq.item.name,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text("${widget.itq.quantity.toStringAsFixed(2)} KgCO2",
              style: const TextStyle(fontSize: 14)),
          trailing: GestureDetector(
              onTap: () {
                removefromcart(widget.itq);
              },
              child: const Icon(Icons.remove)),
        ));
  }
}
