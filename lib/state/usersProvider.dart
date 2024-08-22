import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';

class UsersProvider extends ChangeNotifier {
  // create box
  var userBox = Hive.box<UsersType>('usersBox');
  List<UsersType> userList = [];

  List<int> adminIds = [
    100001,
    200002,
    300003,
    400004,
    500005,
    600006,
    700007,
    800008,
    900009,
  ];

  getUsers() async {
    var data = userBox.values.toList();
    userList = data;
  }

  //get user
  UsersType? getUser(String userKey) {
    var user = userBox.get(userKey);

    return user;
  }

  //get event specific event
  bool containsUser(String id) {
    var event = userBox.containsKey(id);
    return event;
  }

  //create new user
  createNewUser(String userName, int schoolId, String userCourse,
      String userYear, String userPassword, String userProfile) {
    bool isAdmin = false;

    if (adminIds.contains(schoolId)) {
      isAdmin = true;
    }

    userBox.put(
        schoolId.toString(),
        UsersType(
            schoolId: schoolId,
            key: userName,
            userName: userName,
            userCourse: userCourse,
            userYear: userYear,
            userPassword: userPassword,
            isAdmin: isAdmin,
            userProfile: userProfile));
  }

  //insert
  insertData(String id, UsersType user) async {
    await userBox.put(id, user);
    getUsers();
    notifyListeners();
  }

  // updateEventEndedData(int id) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Retrieve the event object
  //     var eventObject = userBox.get(id);

  //     if (eventObject != null) {
  //       // Update the eventEnded property
  //       eventObject.eventEnded = true;
  //       userBox.put(id, eventObject);
  //     }

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  updateEvent(int id, UsersType UsersType) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Save the updated object back to the box
      userBox.put(id, UsersType);

      // Refresh events and notify listeners
      getUsers();
      notifyListeners();
    });
  }

  deleteEvent(int id) async {
    userBox.delete(id);
    getUsers();
    notifyListeners();
  }
}
