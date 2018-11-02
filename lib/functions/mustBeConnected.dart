import 'package:flutter/material.dart';

mustBeConnected(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(content: Text("You must be connected to do this"));
    },
  );
}