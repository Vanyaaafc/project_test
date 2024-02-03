import 'package:hive/hive.dart';


part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  NoteModel({
    required this.noteName,
    required this.noteDescription,
  });

  @HiveField(0)
  String noteName;

  @HiveField(1)
  String noteDescription;

  void saveChanges() {
    save();
  }
}
