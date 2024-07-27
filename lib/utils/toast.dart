import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  void loginSuccessfully(context, String user) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text("Login Successfully"),
      description: Text("Welcome Back ${user}"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void passwordIncorrect(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text("Login Failed"),
      description: Text("Incorrect Password"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void userNotExist(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text("Login Failed"),
      description: Text("User Not Found"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
