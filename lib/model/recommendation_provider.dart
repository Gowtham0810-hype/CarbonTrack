import 'package:flutter/material.dart';

class RecommendationsProvider with ChangeNotifier {
  List<String> _recommendations = [
    "Reduce, reuse, and recycle materials.",
    "Turn off lights when not in use.",
    "Carpool or use public transportation.",
    "Limit air travel to essential trips.",
    "Compost food waste."
  ];

  List<String> get recommendations => _recommendations;

  void setRecommendations(List<String> newRecommendations) {
    _recommendations = newRecommendations;
    notifyListeners();
  }
}
