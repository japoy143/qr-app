import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersProvider extends ChangeNotifier {
  // create box
  var userBox = Hive.box<UsersType>('usersBox');
  List<UsersType> userList = [];

  UsersType userData = UsersType(
      schoolId: 0,
      key: '',
      userName: '',
      userCourse: '',
      userYear: '',
      userPassword: '',
      isAdmin: false,
      userProfile: '');

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

  //offline
  getUsers() async {
    var data = userBox.values.toList();
    userList = data;
  }

  //get user online and offline
  Future<UsersType?> getUser(String userKey) async {
    // check if data  is already save in phone storage or already cache
    if (userBox.containsKey(userKey)) {
      UsersType? user = userBox.get(userKey);
      userData = user!;
      print('if check work');
      return user;
    }

    try {
      var user = await Supabase.instance.client
          .from('users')
          .select("*")
          .eq('school_id', int.parse(userKey))
          .single();

      userData = UsersType(
        schoolId: user['school_id'],
        key: user['key'],
        userName: user['username'],
        userCourse: user['user_course'],
        userYear: user['user_year'],
        userPassword: user['user_password'],
        isAdmin: user['is_admin'],
        userProfile: '',
      );
      notifyListeners();
      return userData;
    } catch (e) {
      //still works even offline
      UsersType? user = userBox.get(userKey);
      userData = user!;
      notifyListeners();
      print('catch');
      return user;
    }
  }

  //get event specific user
  Future<bool> containsUser(String id) async {
    //api
    try {
      var user = await Supabase.instance.client
          .from('users')
          .select("*")
          .eq('school_id', id)
          .single();

      bool userExist = user["school_id"] == int.parse(id);
      print(user["school_id"] == int.parse(id));

      return user.length == 1;
    } catch (e) {
      // encase offline
      var user = userBox.containsKey(id);
      return user;
    }
  }

  //get data for local image
  UsersType? getdataForlocalImage(String id) {
    var user = userBox.get(id);

    return user;
  }

  //create new user
  createNewUser(String userName, int schoolId, String userCourse,
      String userYear, String userPassword, String userProfile) async {
    bool isAdmin = false;
    try {
      if (adminIds.contains(schoolId)) {
        isAdmin = true;
      }
      await Supabase.instance.client.from('users').insert({
        'school_id': schoolId,
        'key': userName,
        'username': userName,
        'user_course': userCourse,
        'user_year': userYear,
        'user_password': userPassword,
        'is_admin': isAdmin,
        'user_profile': userProfile,
      });

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

      print('data inserted successfully');
    } catch (e) {
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

      print('error $e');
    }
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
