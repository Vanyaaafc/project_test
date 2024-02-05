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
  final NoteModel model;

  EditNoteEvent({
    required this.model,
  });

  @override
  List<Object?> get props => [model];
}


class DeleteNoteEvent extends ListScreenEvent {
  final int id;
  final int noteListLength;

  DeleteNoteEvent({required this.id, required this.noteListLength});

  @override
  List<Object?> get props => [id, noteListLength];
}

class SearchNoteEvent extends ListScreenEvent {
  final String keywords;

  SearchNoteEvent({required this.keywords});

  @override
  List<Object?> get props => [keywords];
}

