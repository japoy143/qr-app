import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersProvider extends ChangeNotifier {
  // create box
  var userBox = Hive.box<UsersType>('usersBox');
  List<UsersType> userList = [];

  // shared pref

  UsersType userData = UsersType(
      schoolId: 0,
      key: '',
      userName: '',
      userCourse: '',
      userYear: '',
      userPassword: '',
      isAdmin: false,
      userProfile: '',
      isSignupOnline: false,
      isLogin: false,
      eventAttended: '');

  //user image url
  String? userImage;

  // user scanned image
  String? userScannedImage = '';

  //admin roles
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

  //error code 1**

  //
  //GET
  //

  //101
  //offline
  getUsers() async {
    var data = userBox.values.toList();
    userList = data;
  }

  //102
  getPrefUserData(int id) {
    UsersType? user = userBox.get(id);
    if (user != null) {
      userData = user;
      notifyListeners();
    }
  }

  //103
  //get user online and offline
  Future<UsersType?> getUser(String userKey) async {
    // check if data  is already save in phone storage or already cache

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
          isSignupOnline: true,
          isLogin: user['is_login'],
          eventAttended: user['event_attended']);

      print('data $user');
      print('successfully get user 103');
      notifyListeners();
      return userData;
    } catch (e) {
      //still works even offline
      UsersType? user = userBox.get(userKey);
      if (user != null) {
        userData = user;
      }
      notifyListeners();
      print('error 103 get user $e');
      return user;
    }
  }

  //104
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
      print('User exist 104 $userExist');

      return userExist;
    } catch (e) {
      print('error 104 getting user $e');
      // encase offline
      var user = userBox.containsKey(id);
      return user;
    }
  }

  //105
  //get data for local image
  UsersType? getdataForlocalImage(String id) {
    var user = userBox.get(id);

    return user;
  }

  //106
  //get user image url return response
  void getUserImage(String id) async {
    try {
      final imagePath = '$id/image';

      // check if there is imagepath in the list using id
      final urlResponse =
          await Supabase.instance.client.storage.from('profiles').list();

      List<String?> imagePathList =
          urlResponse.map((item) => item.name).toList();

      if (!imagePathList.contains(id)) {
        userImage = '';
        print('no image in database');
        return;
      }

      // user image
      final userImageUrl = await Supabase.instance.client.storage
          .from('profiles')
          .getPublicUrl(imagePath);

      userImage = userImageUrl.toString();
      notifyListeners();
      print('successfully getting user image 106');
    } catch (e) {
      print('error 106 getting user image');
      userImage = 'off';
      notifyListeners();
      return;
    }
  }

  //107
  //scanned user image
  void getScannedUserImage(String id) async {
    try {
      final imagePath = '$id/image';

      // check if there is imagepath in the list using id
      final urlResponse =
          await Supabase.instance.client.storage.from('profiles').list();

      List<String?> imagePathList =
          urlResponse.map((item) => item.name).toList();

      if (!imagePathList.contains(id)) {
        userScannedImage = '';
        print('no image in database');
        return;
      }

      final userImageUrl = await Supabase.instance.client.storage
          .from('profiles')
          .getPublicUrl(imagePath);

      userScannedImage = userImageUrl.toString();
      notifyListeners();
      print('successfully getting scanned image 107');
    } catch (e) {
      print('error 107 getting scanned image');
      userScannedImage = 'off';
      notifyListeners();
      return;
    }
  }

  //
  //INSERT
  //

  //108
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
        'is_login': false,
        'event_attended': ''
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
              userProfile: userProfile,
              isSignupOnline: true,
              isLogin: false,
              eventAttended: ''));

      print('data inserted successfully 108');
    } catch (e) {
      print('error 108 insertion user $e');
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
              userProfile: userProfile,
              isSignupOnline: false,
              isLogin: false,
              eventAttended: ''));
    }
  }

  //insert
  insertData(String id, UsersType user) async {
    await userBox.put(id, user);
    getUsers();
    notifyListeners();
  }

  //109
  //update status to login
  login(UsersType userData, int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = userData;
    final schoolId = prefs.getInt('school_id');

    if (schoolId != null && schoolId != id) {
      //persist
      await prefs.setInt('school_id', id);
    }

    try {
      await Supabase.instance.client
          .from('users')
          .update({'is_login': true}).eq('school_id', id);

      //set changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userData = UsersType(
            schoolId: user.schoolId,
            key: user.key,
            userName: user.userName,
            userCourse: user.userCourse,
            userYear: user.userYear,
            userPassword: user.userPassword,
            isAdmin: user.isAdmin,
            userProfile: user.userProfile,
            isSignupOnline: user.isSignupOnline,
            isLogin: true,
            eventAttended: user.eventAttended);

        notifyListeners();
        print('successfully login user 109');
      });
    } catch (e) {
      print('error 109 login user $e');
      //offline
      userData = UsersType(
          schoolId: user.schoolId,
          key: user.key,
          userName: user.userName,
          userCourse: user.userCourse,
          userYear: user.userYear,
          userPassword: user.userPassword,
          isAdmin: user.isAdmin,
          userProfile: user.userProfile,
          isSignupOnline: user.isSignupOnline,
          isLogin: true,
          eventAttended: user.eventAttended);

      notifyListeners();
    }
  }

  //110
  //logout callback and dispose all session data
  logout(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      //logout in server
      await Supabase.instance.client
          .from('users')
          .update({'is_login': false}).eq('school_id', id);

      await prefs.setInt('school_id', 0);

      userData = UsersType(
          schoolId: 0,
          key: '',
          userName: '',
          userCourse: '',
          userYear: '',
          userPassword: '',
          isAdmin: false,
          userProfile: '',
          isSignupOnline: false,
          isLogin: false,
          eventAttended: '');

      userImage = '';
      print("successfully Logout user 110");
      notifyListeners();
    } catch (e) {
      print('error 110 logout user $e');
      userData = UsersType(
          schoolId: 0,
          key: '',
          userName: '',
          userCourse: '',
          userYear: '',
          userPassword: '',
          isAdmin: false,
          userProfile: '',
          isSignupOnline: false,
          isLogin: false,
          eventAttended: '');

      notifyListeners();
    }
  }

  //111
  //update user new attended event
  // return status
  Future<bool> updateUserNewAttendedEvent(String newEvent, int id) async {
    try {
      var userData = await Supabase.instance.client
          .from('users')
          .select("*")
          .eq('school_id', id)
          .single();

      var userSchoolId = userData['school_id'];

      if (userSchoolId == null) {
        return false;
      }

      var pastEventAttended = userData['event_attended'];
      var formmatedEvent = '$pastEventAttended$newEvent|';

      await Supabase.instance.client
          .from('users')
          .update({'event_attended': formmatedEvent}).eq('school_id', id);

      print('successfully updated event attended 111');
      return true;
    } catch (e) {
      print('error 111 update  event attended $e');
      var user = userBox.get(id);

      if (user != null) {
        var pastEvent = user.eventAttended;
        var formattedEvent = '$pastEvent|$newEvent';
        user.eventAttended = formattedEvent;
        userBox.put(id, user);

        return true;
      }

      return false;
    }
  }

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
