import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  NoteModel({
    required this.index,
    required this.noteName,
    required this.noteDescription,
  });

  @HiveField(0)
  int index;

  @HiveField(1)
  String noteName;

  @HiveField(2)
  String noteDescription;

  void saveChanges() {
    save();
  }
}
