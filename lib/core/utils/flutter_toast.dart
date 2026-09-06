import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showAppToast({required String message, bool isError = false, String? paymentUrl}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError
        ? Colors.red.withValues(alpha: 1)
        : Colors.green.withValues(alpha: 1),
    textColor: Colors.white,
    fontSize: 14,
  );
}