import 'package:flutter/material.dart';

class CustomSnackbar {
  static customSnackbar(BuildContext context, String content) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
}
