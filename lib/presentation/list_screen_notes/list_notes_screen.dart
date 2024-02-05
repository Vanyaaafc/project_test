import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_comitons_project/core/resources/app_sizes.dart';
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

        //Floating Action Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (modelContext) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.k16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Center(
                              child: Text(
                                AppStrings.addNote,
                                style: AppStyles.textStyleDialogWindow,
                              ),
                            ),
                            const SizedBox(
                              height: AppSizes.k10,
                            ),

                            //Dialog Window Title Text Field
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: AppStrings.titleName,
                                fillColor: Colors.white.withAlpha(235),
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: null,
                            ),
                            const SizedBox(height: AppSizes.k16),

                            //Dialog Window Text TextField
                            TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                labelText: AppStrings.textName,
                                fillColor: Colors.white.withAlpha(235),
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: null,
                            ),
                            const SizedBox(height: AppSizes.k16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //Dialog Window Button - Save -
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (titleController.text.isNotEmpty && textController.text.isNotEmpty) {
                                        final timestamp = DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF;
                                        bloc.add(CreateNewNoteEvent(
                                          model: NoteModel(
                                            id: timestamp,
                                            noteName: titleController.text,
                                            noteDescription: textController.text,
                                          ),
                                        ));
                                        bloc.add(GetAllNotesEvent());
                                        titleController.clear();
                                        textController.clear();
                                        Navigator.pop(context);
                                      }
                                      else if (titleController.text.isEmpty && textController.text.isEmpty) {
                                        showSnackBar(context, AppStrings.fieldCannotBeEmpty);
                                      } else if (titleController.text.isEmpty) {
                                        showSnackBar(context, AppStrings.fillTitleField);
                                      } else if (textController.text.isEmpty) {
                                        showSnackBar(context, AppStrings.fillTextField);
                                      }
                                    });

                                  },
                                  child: const Text(AppStrings.buttonSave),
                                ),


                                //Dialog Window Button - Close -
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(AppStrings
                                              .questionCloseFloatingNote),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                titleController.clear();
                                                textController.clear();
                                                Navigator.pop(context);
                                                Navigator.pop(modelContext);
                                              },
                                              child: const Text(
                                                  AppStrings.answerYes),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                  AppStrings.answerNo),
                                            ),
                                          ],
                                        );
                                      },
                                    );
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.k4, vertical: AppSizes.k2),

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
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppSizes.k16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Center(
                                            child: Text(
                                              AppStrings.editNote,
                                              style: AppStyles
                                                  .textStyleDialogWindow,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: AppSizes.k10,
                                          ),

                                          // Title in Edit Card Info
                                          TextField(
                                            controller: taskNameController,
                                            decoration: InputDecoration(
                                              labelText: AppStrings.titleName,
                                              fillColor:
                                                  Colors.white.withAlpha(235),
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: AppSizes.k16),

                                          //Text in Edit Card Info
                                          TextField(
                                            controller:
                                                taskDescriptionController,
                                            decoration: InputDecoration(
                                              labelText: AppStrings.textName,
                                              fillColor:
                                                  Colors.white.withAlpha(235),
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                            maxLines: null,
                                          ),
                                          const SizedBox(height: AppSizes.k16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              // Button - Save - in Edit Card Info
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (taskNameController
                                                          .text.isEmpty &&
                                                      taskDescriptionController
                                                          .text.isEmpty) {
                                                    showSnackBar(
                                                        context,
                                                        AppStrings
                                                            .fieldCannotBeEmpty);
                                                  } else if (taskNameController
                                                      .text.isEmpty) {
                                                    showSnackBar(
                                                        context,
                                                        AppStrings
                                                            .fillTitleField);
                                                  } else if (taskDescriptionController
                                                      .text.isEmpty) {
                                                    showSnackBar(
                                                        context,
                                                        AppStrings
                                                            .fillTextField);
                                                  } else {
                                                    bloc.add(EditNoteEvent(
                                                      model: NoteModel(
                                                        id: state.noteList[index].id,
                                                        noteName:
                                                            taskNameController
                                                                .text,
                                                        noteDescription:
                                                            taskDescriptionController
                                                                .text,
                                                      ),
                                                    ));
                                                    taskNameController.clear();
                                                    taskDescriptionController
                                                        .clear();
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text(
                                                    AppStrings.buttonSave),
                                              ),

                                              // Button - Cancel - in Edit Card Info
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (modelContext) {
                                                      return AlertDialog(
                                                        title: const Text(AppStrings
                                                            .questionCloseEditNote),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              taskNameController
                                                                  .clear();
                                                              taskDescriptionController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  modelContext);
                                                            },
                                                            child: const Text(
                                                                AppStrings
                                                                    .answerYes),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                AppStrings
                                                                    .answerNo),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                    AppStrings.buttonCancel),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
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
                                  return AlertDialog(
                                    title: const Text(
                                        AppStrings.titleQuestionDelete),
                                    content:
                                        const Text(AppStrings.questionDelete),
                                    actions: [
                                      //Button - Yes - in Delete Card
                                      ElevatedButton(
                                        onPressed: () {
                                          bloc.add(DeleteNoteEvent(
                                            id: state.noteList[index].id,
                                            noteListLength: noteList.length,
                                          ));
                                          Navigator.pop(context);
                                        },
                                        child: const Text(AppStrings.answerYes),
                                      ),

                                      // Button - No - in Delete Card
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

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
