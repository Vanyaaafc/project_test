import 'package:flutter/material.dart';

import 'app_strings.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

bool validate(
    {required String title,
    required String subtitle,
    required BuildContext context}) {
  if (title.isEmpty && subtitle.isEmpty) {
    showSnackBar(context, AppStrings.fieldCannotBeEmpty);
    return false;
  } else if (title.isEmpty) {
    showSnackBar(context, AppStrings.fillTitleField);
    return false;
  } else if (subtitle.isEmpty) {
    showSnackBar(context, AppStrings.fillTextField);
    return false;
  } else {
    return true;
  }
}


