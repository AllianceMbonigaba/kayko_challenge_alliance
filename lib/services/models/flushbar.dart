import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kayko_challenge_alliance/constant/colors.dart';

flushbarMessage(context, message, bool positive) {
  return Flushbar(
    backgroundColor: background,
    messageColor: Colors.black,

    flushbarPosition: FlushbarPosition.TOP,
    message: message,
    icon: positive
        ? Icon(
            Icons.check,
            size: 28,
            color: yellow,
          )
        : Icon(
            Icons.warning,
            size: 28,
            color: Colors.red,
          ),
    // leftBarIndicatorColor: Colors.blue.shade300,
    duration: Duration(seconds: 5),
  )..show(context);
}
