import 'package:flutter/material.dart';
import 'package:portal/utils/cat.dart';
import 'package:portal/utils/catitem.dart';
import 'package:portal/utils/item.dart';

class Categorytosubcategory extends StatefulWidget {
  final Cat category;
  // List of Item objects
  const Categorytosubcategory({required this.category, super.key});

  @override
  State<Categorytosubcategory> createState() => _CategorytosubcategoryState();
}

class _CategorytosubcategoryState extends State<Categorytosubcategory> {
  double boxh = 100.0;
  double boxw = 400.0;
  bool showList = false; // Toggle between showing the text and list

  void _expandbox() {
    setState(() {
      boxh = boxh == 100 ? 300 : 100;

      showList = !showList; // Toggle the view
    });
  }

  // Placeholder for animation end action
  void changeView() {
    print('Animation ended!');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _expandbox,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            AnimatedContainer(
              margin: const EdgeInsets.only(
                  bottom: 10, left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(12)),
              transformAlignment: Alignment.topCenter,
              onEnd: changeView,
              width: boxw,
              height: boxh,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutQuart,
              child: Center(
                child: showList
                    ? SizedBox(
                        height: boxh, // Ensure the height accommodates the list
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: widget.category.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.category.items[index];
                            return Catitem(
                              icon: const Icon(Icons.abc),
                              item: item,
                            );
                          },
                        ),
                      )
                    : Text(
                        widget.category.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
