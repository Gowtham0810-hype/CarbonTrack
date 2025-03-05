class EmType {
  String name;
  String metrics;
  String measurement;
  EmType({
    required this.name,
    required this.metrics,
    required this.measurement,
  });
}

class Item {
  final String name;
  final double emission;
  final EmType emType;

  Item({required this.name, required this.emission, required this.emType});
}
