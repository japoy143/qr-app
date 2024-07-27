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

  void userIdNotCorrect(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text("Login Failed"),
      description: Text("User id not correct"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void successfullyCreatedUser(context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text("Account Created"),
      description: Text("Account Successfully Created"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void errorCreationUser(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text("User Not Created"),
      description: Text("Please fill the forms"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
