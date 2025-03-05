// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:portal/components/frostedbox.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Airecom extends StatefulWidget {
  const Airecom({super.key});

  @override
  State<Airecom> createState() => _AirecomState();
}

class _AirecomState extends State<Airecom> {
  List<String> _geminiResponses = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedResponses = prefs.getStringList('geminiResponses');
    if (savedResponses != null) {
      setState(() {
        _geminiResponses = savedResponses;
      });
    } else {
      // Initialize with predefined placeholder recommendations if none saved
      _geminiResponses = [
        "Reduce, reuse, and recycle materials.",
        "Turn off lights when not in use.",
        "Carpool or use public transportation.",
        "Limit air travel to essential trips.",
        "Compost food waste."
      ];
    }
  }

  Future<void> _fetchRecommendations() async {
    String apiKey = 'AIzaSyCxbFB6l71d3H_ocYt6dpxx4ZVcxiBDUDA';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    // Analyze the usercart to create a description of current emission sources
    final categoriesList = Provider.of<CategoriesList>(context, listen: false);
    String cartDescription = categoriesList.usercart
        .map((item) => "${item.item.name} : ${item.quantity} kg CO2")
        .join(", ");
    print(cartDescription);

    // Generate a prompt with user-specific data
    final msg =
        "Based on the following items in my cart: $cartDescription, provide 5 personalized one-line recommendations to help reduce carbon emissions. Include actionable steps based on the types and amounts of emissions listed. Just provide the recommendations only.";
    final content = Content.text(msg);

    // Generate recommendations
    final response = await model.generateContent([content]);
    List<String> newRecommendations = response.text?.split('\n') ?? [];

    // Ensure we have exactly 5 recommendations
    if (newRecommendations.length < 5) {
      newRecommendations.addAll(List<String>.filled(
          5 - newRecommendations.length, "Additional recommendation needed."));
    } else if (newRecommendations.length > 5) {
      newRecommendations = newRecommendations.sublist(0, 5);
    }

    setState(() {
      _geminiResponses = newRecommendations;
    });

    // Save recommendations to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('geminiResponses', newRecommendations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background image container

          RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: Colors.green[100],
            strokeWidth: 4.0,
            onRefresh: () async {
              // Fetch new recommendations
              await _fetchRecommendations();
              // Simulate refresh delay
              return Future<void>.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              itemCount: _geminiResponses.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Frostedbox(
                    width: 200.0,
                    height: 125.0,
                    child: Text(
                      _geminiResponses[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors
                            .black, // Change text color to black for better contrast
                        fontSize: 16, // Slightly larger font size
                        fontWeight: FontWeight
                            .w500, // Medium weight for better readability
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor:
          Colors.transparent, // Ensure Scaffold has a transparent background
    );
  }
}
