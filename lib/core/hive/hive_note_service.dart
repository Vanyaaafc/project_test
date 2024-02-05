import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../data/model/note_model.dart';

class HiveNoteService {
  Future<void> addNoteToBox(NoteModel model) async {
    try {
      final box = await Hive.openBox<NoteModel>('note_box');
      box.put(model.id, model);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNoteFromBox(int id) async {
    final box = await Hive.openBox<NoteModel>('note_box');
    box.delete(id);
  }

  Future<List<NoteModel>> getAllNotesFromBox() async {
    final box = await Hive.openBox<NoteModel>('note_box');
    final result = box.values.toList();
    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }

  Future<void> editNoteInBox(NoteModel updatedModel) async {
    final box = await Hive.openBox<NoteModel>('note_box');

    final noteToUpdate = box.get(updatedModel.id);

    if (noteToUpdate != null) {
      noteToUpdate.noteName = updatedModel.noteName;
      noteToUpdate.noteDescription = updatedModel.noteDescription;
      noteToUpdate.saveChanges();
    }
  }

  Future<List<NoteModel>> searchNotes(String keyword) async {
    final box = await Hive.openBox<NoteModel>('note_box');
    final allNotes = box.values.toList();

    final filteredNotes = allNotes.where((note) =>
        note.noteName.toLowerCase().contains(keyword.toLowerCase()) ||
        note.noteDescription.toLowerCase().contains(keyword.toLowerCase()));

    return filteredNotes.toList();
  }
}
