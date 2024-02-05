import 'package:hive_flutter/hive_flutter.dart';

import '../../data/model/note_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
}