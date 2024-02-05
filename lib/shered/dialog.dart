import 'package:flutter/material.dart';
import '../core/resources/abs_func.dart';
import '../core/resources/app_sizes.dart';
import '../core/resources/app_strings.dart';
import '../core/resources/app_styles.dart';
import '../data/model/note_model.dart';
import '../presentation/list_screen_notes/list_screen_bloc/list_screen_bloc.dart';

class SimpleConfirmCancelDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String title;

  const SimpleConfirmCancelDialog(
      {super.key,
      required this.onConfirm,
      required this.onCancel,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text(AppStrings.answerYes),
        ),
        ElevatedButton(
          onPressed: onCancel,
          child: const Text(AppStrings.answerNo),
        ),
      ],
    );
  }
}

class CreateNoteDialog extends StatefulWidget {
  final Function(String, String) onConfirm;
  final VoidCallback onCancel;

  const CreateNoteDialog(
      {super.key, required this.onConfirm, required this.onCancel});

  @override
  State<CreateNoteDialog> createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  controller: _titleController,
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
                  controller: _textController,
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
                        if (validate(
                            title: _titleController.text,
                            subtitle: _textController.text,
                            context: context)) {
                          widget.onConfirm(
                              _titleController.text, _textController.text);
                          _titleController.clear();
                          _textController.clear();
                        }
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
                              return SimpleConfirmCancelDialog(
                                onConfirm: () {
                                  _textController.clear();
                                  _titleController.clear();
                                  Navigator.of(context).pop();
                                },
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                                title: AppStrings.questionCloseFloatingNote,
                              );
                            });
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
  }
}

class AlertDialogInEdit extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AlertDialogInEdit({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AlertDialogInEdit> createState() => _AlertDialogInEditState();
}

class _AlertDialogInEditState extends State<AlertDialogInEdit> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.questionCloseEditNote),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onConfirm();
            Navigator.pop(context);
          },
          child: const Text(AppStrings.answerYes),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCancel();
          },
          child: const Text(AppStrings.answerNo),
        ),
      ],
    );
  }
}

class AlertDialogInDelete extends StatefulWidget {
  final int id;
  final int index;
  final int noteListLength;
  final ListScreenBloc bloc;
  final VoidCallback onDelete;

  const AlertDialogInDelete({
    Key? key,
    required this.id,
    required this.index,
    required this.noteListLength,
    required this.bloc,
    required this.onDelete,
  }) : super(key: key);

  @override
  _AlertDialogInDeleteState createState() => _AlertDialogInDeleteState();
}

class _AlertDialogInDeleteState extends State<AlertDialogInDelete> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.titleQuestionDelete),
      content: const Text(AppStrings.questionDelete),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.bloc.add(DeleteNoteEvent(
              id: widget.id,
              noteListLength: widget.noteListLength,
            ));
            widget.onDelete();
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
  }
}

class EditNoteDialog extends StatefulWidget {
  final ListScreenBloc bloc;
  final int noteId;
  final String initialTitle;
  final String initialDescription;
  final VoidCallback onEdit;

  const EditNoteDialog({
    Key? key,
    required this.bloc,
    required this.noteId,
    required this.initialTitle,
    required this.initialDescription,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.initialTitle;
    taskDescriptionController.text = widget.initialDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.k16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                AppStrings.editNote,
                style: AppStyles.textStyleDialogWindow,
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
                fillColor: Colors.white.withAlpha(235),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.k16),

            // Text in Edit Card Info
            TextField(
              controller: taskDescriptionController,
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
                // Button - Save - in Edit Card Info
                ElevatedButton(
                  onPressed: () {
                    if (validate(
                        title: taskNameController.text,
                        subtitle: taskDescriptionController.text,
                        context: context)) {
                      widget.bloc.add(EditNoteEvent(
                        model: NoteModel(
                          id: widget.noteId,
                          noteName: taskNameController.text,
                          noteDescription: taskDescriptionController.text,
                        ),
                      ));
                      taskNameController.clear();
                      taskDescriptionController.clear();
                      widget.onEdit();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(AppStrings.buttonSave),
                ),

                // Button - Cancel - in Edit Card Info
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (modelContext) {
                        return AlertDialogInEdit(
                          onConfirm: () {
                            taskNameController.clear();
                            taskDescriptionController.clear();
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  child: const Text(AppStrings.buttonCancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
