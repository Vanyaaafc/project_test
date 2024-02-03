


import 'package:hive_flutter/hive_flutter.dart';

import '../../data/model/note_model.dart';

class HiveNoteService {

  Future<void> addNoteToBox(NoteModel model) async {
    final box = await Hive.openBox<NoteModel>('note_box');
    box.add(model);
  }

  Future<void> deleteNoteFromBox(int index) async {
    final box = await Hive.openBox<NoteModel>('note_box');
    box.deleteAt(index);
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

  Future<void> editNoteInBox(int index, NoteModel updatedModel) async {
    final box = await Hive.openBox<NoteModel>('note_box');

    if (index >= 0 && index < box.length) {
      // Знаходимо нотатку за індексом
      final noteToUpdate = box.getAt(index);

      // Перевіряємо, чи знайдена нотатка не є null
      if (noteToUpdate != null) {
        // Оновлюємо текст нотатки
        noteToUpdate.noteName = updatedModel.noteName;
        noteToUpdate.noteDescription = updatedModel.noteDescription;

        // Викликаємо метод saveChanges для автоматичного збереження змін
        noteToUpdate.saveChanges();
      }
    }
  }
}
