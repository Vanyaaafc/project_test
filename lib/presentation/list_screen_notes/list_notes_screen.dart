import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_comitons_project/core/resources/app_sizes.dart';
import '../../core/di/injection_container.dart';
import '../../core/resources/app_strings.dart';
import '../../core/resources/app_styles.dart';
import '../../data/model/note_model.dart';
import '../../shered/dialog.dart';
import 'list_screen_bloc/list_screen_bloc.dart';

class ListNotesScreen extends StatefulWidget {
  const ListNotesScreen({
    super.key,
  });

  @override
  State<ListNotesScreen> createState() => _ListNotesScreenState();
}

class _ListNotesScreenState extends State<ListNotesScreen> {
  final bloc = locator.get<ListScreenBloc>();
  final TextEditingController _searchTextEditController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc..add(GetAllNotesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appBarMainName),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            //Search TextField
            Padding(
              padding: const EdgeInsets.all(AppSizes.k8),
              child: TextField(
                controller: _searchTextEditController,
                decoration: const InputDecoration(
                  hintText: AppStrings.searchNameTextField,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    bloc.add(GetAllNotesEvent());
                  } else {
                    bloc.add(SearchNoteEvent(keywords: value));
                  }
                },
              ),
            ),
            Expanded(
              child: _View(
                onEdit: () {
                  _searchTextEditController.clear();
                },
                onDelete: () {
                  _searchTextEditController.clear();
                },
              ),
            ),
          ],
        ),

        //Floating Action Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (modelContext) {
                return CreateNoteDialog(
                  onConfirm: (title, subtitle) {
                    final timestamp =
                        DateTime
                            .now()
                            .millisecondsSinceEpoch % 0xFFFFFFFF;
                    bloc.add(CreateNewNoteEvent(
                      model: NoteModel(
                        id: timestamp,
                        noteName: title,
                        noteDescription: subtitle,
                      ),
                    ));
                    bloc.add(GetAllNotesEvent());

                    Navigator.pop(context);
                  },
                  onCancel: () {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _View({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  });

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
      bloc: bloc,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.k4, vertical: AppSizes.k2),

                  // Show Card Detail
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

                    //Card
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Name in Card
                                Padding(
                                  padding: AppStyles.paddingNote,
                                  child: Text(
                                    noteList[index].noteName,
                                    style: AppStyles.titleStyle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSizes.k10,
                                ),

                                // Text name in Card
                                Padding(
                                  padding: AppStyles.paddingNote,
                                  child: Text(
                                    noteList[index].noteDescription,
                                    style: AppStyles.textStyleStandart,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Button Edit Card Info
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return EditNoteDialog(bloc: bloc,
                                      noteId: state.noteList[index].id,
                                      initialTitle: state.noteList[index].noteName,
                                      initialDescription: state.noteList[index].noteDescription,
                                      onEdit: widget.onEdit);
                                },
                              );
                              taskNameController.text =
                                  noteList[index].noteName;
                              taskDescriptionController.text =
                                  noteList[index].noteDescription;
                            },
                          ),

                          //Button Delete Card
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialogInDelete(
                                    id: state.noteList[index].id,
                                    index: index,
                                    noteListLength: noteList.length,
                                    bloc: bloc,
                                    onDelete: widget.onDelete,
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

          // States
        } else if (state is ListScreenIsEmpty) {
          return const Center(child: Text(AppStrings.stringListScreenIsEmpty));
        } else if (state is ListScreenIsError) {
          return Center(child: Text(state.message));
        } else if (state is NoteNotFound) {
          return const Center(child: Text(AppStrings.stringNoteNotFound));
        } else {
          return const Center(child: Text(AppStrings.stringUnknownState));
        }
      },
    );
  }
}
