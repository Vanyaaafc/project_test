import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/hive/hive_note_service.dart';
import '../../../data/model/note_model.dart';

part 'list_screen_event.dart';
part 'list_screen_state.dart';

class ListScreenBloc extends Bloc<ListScreenEvent, ListScreenState> {
  final HiveNoteService noteService;

  ListScreenBloc({required this.noteService}) : super(ListScreenInitial()) {
    on<GetAllNotesEvent>((event, emit) async {
      await getAllNotes(event, emit);
    });
    on<CreateNewNoteEvent>((event, emit) async {
      await addNote(event, emit);
    });
    on<DeleteNoteEvent>((event, emit) async {
      await deleteNote(event, emit);
    });
    on<EditNoteEvent>((event, emit) async {
      await editNote(event, emit);
    });
  }

  Future<void> addNote(CreateNewNoteEvent event,
      Emitter<ListScreenState> emit) async {
    emit(AddNoteState());
    try {
      await noteService.addNoteToBox(event.model);
      emit(NoteIsAddedState());
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  Future<void> deleteNote(DeleteNoteEvent event,
      Emitter<ListScreenState> emit) async {
    try {
      await noteService.deleteNoteFromBox(event.index);
      if(event.noteListLength <= 1 ){
        emit(ListScreenIsEmpty());
      }
      else {
        final result = await noteService.getAllNotesFromBox();
        emit(ListScreenIsLoaded(noteList: result));
      }
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  Future<void> getAllNotes(GetAllNotesEvent event, Emitter<ListScreenState> emit) async {
    emit(ListScreenIsLoading());
    try{
      final result = await noteService.getAllNotesFromBox();
      if(result.isEmpty){
        emit(ListScreenIsEmpty());
      }
      else {
        emit(ListScreenIsLoaded(noteList: result));
      }
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }

  Future<void> editNote(EditNoteEvent event, Emitter<ListScreenState> emit) async {
    emit(EditNoteState());
    try {
      await noteService.editNoteInBox(event.index, event.model);
      final result = await noteService.getAllNotesFromBox();
      emit(ListScreenIsLoaded(noteList: result));
    } catch (e) {
      emit(NoteListError(message: e.toString()));
    }
  }
 }
