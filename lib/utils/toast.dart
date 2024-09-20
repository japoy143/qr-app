import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:vibration/vibration.dart';

class CustomToast {
  void loginSuccessfully(BuildContext context, String user) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Login Successfully"),
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
      title: const Text("Login Failed"),
      description: const Text("Incorrect Password"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
    Vibration.vibrate();
  }

  void usernameIncorrect(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Login Failed"),
      description: const Text("Incorrect Username"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
    Vibration.vibrate();
  }

  void userNotExist(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Login Failed"),
      description: const Text("User Not Found"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
    Vibration.vibrate();
  }

  void userIdNotCorrect(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Login Failed"),
      description: const Text("User id not correct"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
    Vibration.vibrate();
  }

// user creation toast
  void successfullyCreatedUser(context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Account Created"),
      description: const Text("Account Successfully Created"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void errorCreationUser(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("User Not Created"),
      description: const Text("Please fill the forms"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void passwordLengthError(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("User Not Created"),
      description: const Text("Password must be at least 8 characters"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void passwordNotSame(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("User Not Created"),
      description: const Text("Password must be thesame"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void userAlreadyExist(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("User Not Created"),
      description: const Text("User already in use"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  //events
  void errorCreationEvent(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Event Not Created"),
      description: const Text("Please fill the input fields"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void errorEventIdAlreadyUsed(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Event Not Created"),
      description: const Text("Event Id Already use"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void errorEventEnd(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Event Not Created"),
      description: const Text("Event Time Must Be After The Event Start Time"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void errorEventTimeNotSet(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Event Not Created"),
      description: const Text("Please Set Event Time"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  // userScreen

  void profileSuccessfullyChange(context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("User Profile"),
      description: Text("Profile Picture Changed"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  // Scanner
  void errorStudentNotSave(context) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text("Error Attendance"),
      description: const Text("Student Data Not Save"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );

    Vibration.vibrate();
  }

  void AttendanceSuccessfullySave(context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Attendance Save"),
      description: Text("Student Successfully Save"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void AlreadyAttended(context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Attendance Already Save"),
      description: Text("User Already Attended At The Event"),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
