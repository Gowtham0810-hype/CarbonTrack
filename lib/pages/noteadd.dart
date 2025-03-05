// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';
import 'package:portal/model/notes_repository.dart';
import 'package:portal/utils/item.dart';
import 'package:portal/utils/notes.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:portal/model/categoriesList.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesRepository _repository = NotesRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late EmType emType = EmType(name: '', measurement: '', metrics: '');

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    await _repository.loadNotes();
    setState(() {});
  }

  void _addNote() async {
    final note = Note(
      id: DateTime.now().toString(),
      title: _titleController.text,
      content: _contentController.text,
      dateCreated: DateTime.now(),
    );
    await _repository.addNoteAndSave(note);
    setState(() {});
    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add from Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(onPressed: _addNote, child: Text('Save')),
          TextButton(
            onPressed: () {
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteNoteAndSave(String id) async {
    await _repository.deleteNoteAndSave(id);
    setState(() {});
  }

  void _editNoteAndSave(Note note) {
    _titleController.text = note.title;
    _contentController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _repository.updateNoteAndSave(
                  note.id, _titleController.text, _contentController.text);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  ItemWithQuantity createItemFromCommaSeparatedString(String output) {
    // Split the string by commas and trim any extra spaces
    List<String> parts = output.split(',').map((part) => part.trim()).toList();

    if (parts.length != 6) {
      throw Exception('Invalid input format');
    }

    String name = parts[0]; // The first part is the item name
    double emission = double.parse(
        parts[1]); // The second part is the emission, converted to double

    emType.name = parts[2];
    emType.measurement = parts[4];
    emType.metrics = parts[3];
    Item itq = Item(name: name, emission: emission, emType: emType);
// The third part is the emType, mapped to EmType object
    double val = double.parse(parts[5]);
    // Create and return the Item object
    return ItemWithQuantity(itq, val);
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

  Future<void> sendNote(BuildContext context, String noteContent) async {
    String apiKey = 'AIzaSyCxbFB6l71d3H_ocYt6dpxx4ZVcxiBDUDA';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final msg = '''
  Here is a database of items along with their carbon footprint emission types (EmType). Each item has an emission value and is associated with an EmType, which describes how the emissions are measured (e.g., by quantity, distance, etc.).

  EmType examples:
  1. Purchase: measured by quantity (item(s)).
  2. Transport: measured by distance (km(s)).
  3. Meal: measured by quantity (meal(s)).
  4. Streaming: measured by duration (hour(s)).
  5. Fashion: measured by quantity (item(s)).
  6. Food: measured by quantity (g).

  Here is a list of items and their emissions:

  **Purchase Items:**
  - SmartPhone: 80
  - Laptop: 210
  - Tablet: 87
  - Computer: 588
  - Television: 500
  - Electric Car: 8800
  - Hybrid Car: 6500

  **Transport Items:**
  - Train: 0.084 (per km)
  - Car: 38.55 (per km)
  - Bus: 15.45 (per km)
  - Plane: 453.77 (per km)
  - MotorBike: 16.2 (per km)

  **Meal Items:**
  - High Meat: 2.16 (per meal)
  - Medium Meat: 1.69 (per meal)
  - Vegan: 0.867 (per meal)

  **Fashion Items:**
  - Coat: 51 (per item)
  - Dress: 54.33 (per item)
  - T-Shirt: 7.67 (per item)

  **Food Items:**
  - Meat: 3.5 (per g)
  - Coffee: 0.628 (per g)
  - Chocolate: 0.974 (per g)
  - Milk: 0.38 (per g)
  -Potatoes : 0.58 (per g)

  **Streaming Items:**
  - Audio-MP3: 0.033 (per hour)
  - Video-Full HD: 0.135 (per hour)

  Based on the note content below, identify an item from the database:
  
  "$noteContent"
  
  If the item appears in the database, just return its details in the format: item name,value,EmType,measured by,metric used,total emission. If the item is not listed in the database, create a new item with a reasonable emission value and assign it an appropriate EmType from the list and just return details in the format: item name,value,EmType,measured by,metric used,total emission without any explanation.
  ''';

    final content = Content.text(msg);
    final response = await model.generateContent([content]);

    print("Response from gemini: ${(response.text)}");

    ItemWithQuantity newItem =
        createItemFromCommaSeparatedString(response.text ?? "");
    addItemtocart(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Notes'),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        backgroundColor: Colors.green[200],
      ),
      body: ListView.builder(
        itemCount: _repository.notes.length,
        itemBuilder: (context, index) {
          final note = _repository.notes[index];
          return Column(
            children: [
              SizedBox(height: 10),
              Dismissible(
                key: Key(note.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  sendNote(context, note.content);
                  _deleteNoteAndSave(note.id);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.green[200],
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    note.content,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editNoteAndSave(note)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNoteAndSave(note.id)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
