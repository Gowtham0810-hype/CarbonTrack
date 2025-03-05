import 'dart:convert';
import 'package:portal/utils/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesRepository {
  final List<Note> _notes = [];
  final String _storageKey = 'notes_storage';

  List<Note> get notes => List.unmodifiable(_notes);

  Future<void> addNoteAndSave(Note note) async {
    _notes.add(note);
    await saveNotes();
  }

  Future<void> updateNoteAndSave(
      String id, String title, String content) async {
    final noteIndex = _notes.indexWhere((note) => note.id == id);
    if (noteIndex != -1) {
      _notes[noteIndex].title = title;
      _notes[noteIndex].content = content;
      await saveNotes();
    }
  }

  Future<void> deleteNoteAndSave(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await saveNotes();
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = jsonEncode(_notes.map((note) => note.toJson()).toList());
    await prefs.setString(_storageKey, notesJson);
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString(_storageKey);
    if (notesJson != null) {
      final List<dynamic> notesData = jsonDecode(notesJson);
      _notes.clear();
      _notes.addAll(notesData.map((data) => Note.fromJson(data)));
    }
  }
}
