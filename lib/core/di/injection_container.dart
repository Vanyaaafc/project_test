import 'package:get_it/get_it.dart';
import 'package:test_comitons_project/core/hive/hive_note_service.dart';
import 'package:test_comitons_project/presentation/list_screen_notes/list_screen_bloc/list_screen_bloc.dart';


GetIt locator = GetIt.instance;

Future<void> initDI() async {
  locator.registerSingleton<HiveNoteService>(HiveNoteService());
  locator.registerLazySingleton(() => ListScreenBloc(noteService: locator<HiveNoteService>()));
}