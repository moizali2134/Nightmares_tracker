

 import 'package:flutter/material.dart';

ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  minimumSize: Size(88, 44),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  backgroundColor: Colors.blue,
);