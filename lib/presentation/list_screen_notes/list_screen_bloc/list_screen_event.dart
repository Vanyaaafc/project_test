part of 'list_screen_bloc.dart';

@immutable
abstract class ListScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllNotesEvent extends ListScreenEvent {}

class CreateNewNoteEvent extends ListScreenEvent {
  final NoteModel model;

  CreateNewNoteEvent({required this.model});

  @override
  List<Object?> get props => [model];
}

class EditNoteEvent extends ListScreenEvent {
  final int index;
  final NoteModel model;

  EditNoteEvent({
    required this.index,
    required this.model,
  });

  @override
  List<Object?> get props => [index, model];
}


class DeleteNoteEvent extends ListScreenEvent {
  final int index;
  final int noteListLength;

  DeleteNoteEvent({required this.index, required this.noteListLength});

  @override
  List<Object?> get props => [index, noteListLength];
}

class SearchNoteEvent extends ListScreenEvent {}

