import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../core/resources/app_strings.dart';
import '../../core/resources/app_styles.dart';
import '../../data/model/note_model.dart';
import 'list_screen_bloc/list_screen_bloc.dart';

class ListNotesScreen extends StatefulWidget {
  const ListNotesScreen({Key? key});

  @override
  State<ListNotesScreen> createState() => _ListNotesScreenState();
}

class _ListNotesScreenState extends State<ListNotesScreen> {
  final bloc = locator.get<ListScreenBloc>();
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc..add(GetAllNotesEvent()),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appBarMainName),
            backgroundColor: Colors.amber,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.searchNameTextField,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    bloc.add(SearchNoteEvent(keywords: value));
                  },
                ),
              ),
              Expanded(
                child: _View(bloc: bloc),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Center(
                                child: Text(
                                  AppStrings.addNote,
                                  style: AppStyles.textStyle,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  labelText: AppStrings.titleName,
                                  fillColor: Colors.white.withAlpha(235),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  labelText: AppStrings.textName,
                                  fillColor: Colors.white.withAlpha(235),
                                  border: const OutlineInputBorder(),
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (titleController.text.isNotEmpty &&
                                            textController.text.isNotEmpty) {
                                          bloc.add(CreateNewNoteEvent(
                                            model: NoteModel(
                                              noteName: titleController.text,
                                              noteDescription: textController.text,
                                            ),
                                          ));
                                          titleController.clear();
                                          textController.clear();
                                          bloc.add(GetAllNotesEvent());
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                    child: const Text(AppStrings.buttonSave),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(AppStrings.buttonClose),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({Key? key, required this.bloc});

  final ListScreenBloc bloc;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final bloc = locator.get<ListScreenBloc>();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListScreenBloc, ListScreenState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is ListScreenIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ListScreenIsLoaded) {
          final noteList = state.noteList;
          return ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: AppStyles.paddingNote,
                                child: Text(noteList[index].noteName),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: AppStyles.paddingNote,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(noteList[index].noteName),
                                          content: Text(noteList[index].noteDescription),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    noteList[index].noteDescription,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: taskNameController,
                                          decoration: InputDecoration(
                                            labelText: AppStrings.titleName,
                                            fillColor: Colors.white.withAlpha(235),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextField(
                                          controller: taskDescriptionController,
                                          decoration: InputDecoration(
                                            labelText: AppStrings.textName,
                                            fillColor: Colors.white.withAlpha(235),
                                            border: const OutlineInputBorder(),
                                          ),
                                          maxLines: null,
                                        ),
                                        const SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (taskNameController.text.isEmpty && taskDescriptionController.text.isEmpty) {
                                                  showSnackBar(context, "Fields cannot be empty");
                                                } else if (taskNameController.text.isEmpty) {
                                                  showSnackBar(context, "Fill in the title field");
                                                } else if (taskDescriptionController.text.isEmpty) {
                                                  showSnackBar(context, "Fill in the text field");
                                                } else {
                                                  bloc.add(EditNoteEvent(
                                                    index: index,
                                                    model: NoteModel(
                                                      noteName: taskNameController.text,
                                                      noteDescription: taskDescriptionController.text,
                                                    ),
                                                  ));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text(AppStrings.buttonSave),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(AppStrings.buttonCancel),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            taskNameController.text = noteList[index].noteName;
                            taskDescriptionController.text = noteList[index].noteDescription;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(AppStrings.titleQuestionDelete),
                                  content: const Text(AppStrings.questionDelete),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        bloc.add(DeleteNoteEvent(
                                          index: index,
                                          noteListLength: noteList.length,
                                        ));
                                        Navigator.pop(context);
                                      },
                                      child: const Text(AppStrings.answerYes),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(AppStrings.answerNo),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ListScreenIsEmpty) {
          return const Center(child: Text('List is empty. Please add note'));
        } else if (state is ListScreenIsError) {
          return Center(child: Text(state.message));
        } else if (state is NoteNotFound){
          return const Center(child: Text('Note not found'));
        }
        else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
