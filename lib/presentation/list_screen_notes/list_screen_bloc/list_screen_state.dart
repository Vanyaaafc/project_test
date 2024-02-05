part of 'list_screen_bloc.dart';

@immutable
abstract class ListScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

//For List
class ListScreenInitial extends ListScreenState {}

class ListScreenIsLoading extends ListScreenState {}

class ListScreenIsLoaded extends ListScreenState {
  final List<NoteModel> noteList;

  ListScreenIsLoaded({required this.noteList});

  @override
  List<Object> get props => [noteList];

  @override
  String toString() => 'List Screen Is Loaded: $noteList';
}

class ListScreenIsEmpty extends ListScreenState {
  final List<NoteModel> noteList;

  ListScreenIsEmpty({required this.noteList});

  @override
  List<Object> get props => [noteList];

  @override
  String toString() => 'List Screen Is Loaded: $noteList';
}

class NoteNotFound extends ListScreenState {}

//For Note
class AddNoteState extends ListScreenState {}

class NoteIsAddedState extends ListScreenState {}

class NoteDeletedState extends ListScreenState {}

class EditNoteState extends ListScreenState {}


class ListScreenIsError extends ListScreenState {
  final String message;

  ListScreenIsError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoteListError extends ListScreenState {
  final String message;

  NoteListError({required this.message});

  @override
  List<Object> get props => [message];
}
