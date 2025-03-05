// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/utils/emissioncart.dart';
import 'package:portal/utils/item.dart';
import 'package:provider/provider.dart';

class Emissionlist extends StatefulWidget {
  const Emissionlist({super.key});

  @override
  State<Emissionlist> createState() => _EmissionlistState();
}

class _EmissionlistState extends State<Emissionlist> {
  @override
  Widget build(BuildContext context) {
    // Get the current month name
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Consumer<CategoriesList>(
      builder: (context, value, child) {
        double electronicval = 10;
        double foodval = 10;
        double mealval = 10;
        double fashionval = 10;
        double streamval = 10;
        double travelval = 10;
        double total = 0;

        // Calculate the total and individual values outside the build process
        for (var _itq in value.getcat()) {
          total += _itq.quantity;

          if (_itq.item.emType.name == 'Purchase') {
            electronicval += _itq.quantity;
          }
          if (_itq.item.emType.name == 'Food') {
            foodval += _itq.quantity;
          }
          if (_itq.item.emType.name == 'Meal') {
            mealval += _itq.quantity;
          }
          if (_itq.item.emType.name == 'Fashion') {
            fashionval += _itq.quantity;
          }
          if (_itq.item.emType.name == 'Streaming') {
            streamval += _itq.quantity;
          }
          if (_itq.item.emType.name == 'Transport') {
            travelval += _itq.quantity;
          }
        }
        void signout() {
          FirebaseAuth.instance.signOut();
        }

        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            actions: [IconButton(onPressed: signout, icon: Icon(Icons.logout))],
            title: Text('Your Emissions'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
            backgroundColor: Colors.grey.shade200,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.getcat().length,
                  itemBuilder: (context, index) {
                    ItemWithQuantity itq = value.getcat()[index];
                    return Emissioncart(itq: itq);
                  },
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "$currentMonth : ${total.toStringAsFixed(2)} KgCo2",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Emissions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: PieChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 750),
                          swapAnimationCurve: Curves.easeInOutQuint,
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                title: 'Purchase',
                                value: electronicval,
                                color: Colors.green[100],
                              ),
                              PieChartSectionData(
                                title: 'Travel',
                                value: travelval,
                                color: Colors.green[300],
                              ),
                              PieChartSectionData(
                                title: 'Food',
                                value: foodval,
                                color: Colors.green[500],
                              ),
                              PieChartSectionData(
                                title: 'Meal',
                                value: mealval,
                                color: Colors.green[200],
                              ),
                              PieChartSectionData(
                                title: 'Fashion',
                                value: fashionval,
                                color: Colors.green[400],
                              ),
                              PieChartSectionData(
                                title: 'Stream',
                                value: streamval,
                                color: Colors.green[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Top Emissions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: total + 10,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipPadding: EdgeInsets.all(8),
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  String category;
                                  switch (group.x.toInt()) {
                                    case 0:
                                      category = 'Electronics';
                                      break;
                                    case 1:
                                      category = 'Travel';
                                      break;
                                    case 2:
                                      category = 'Food';
                                      break;
                                    default:
                                      category = '';
                                  }
                                  return BarTooltipItem(
                                    '$category\n',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const categories = [
                                      'Electronics',
                                      'Travel',
                                      'Food'
                                    ];
                                    return Text(
                                      categories[value.toInt()],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    );
                                  },
                                  reservedSize: 30,
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: electronicval,
                                    color: Colors.green[100],
                                    width: 30,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: travelval,
                                    color: Colors.green[300],
                                    width: 30,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: foodval,
                                    color: Colors.green[500],
                                    width: 30,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
