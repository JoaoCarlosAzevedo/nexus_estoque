import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showErrorWidget(BuildContext context, String error) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          desc: error,
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor)
      .show();
}
