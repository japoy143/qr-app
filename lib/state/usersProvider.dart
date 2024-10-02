import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsersProvider extends ChangeNotifier {
  //logger
  var logger = Logger();
  // create box
  var userBox = Hive.box<UsersType>('usersBox');
  var sessionBox = Hive.box('sessionBox');

  List<UsersType> userList = [];

  Map<String?, String> userImageList = {};

  // shared pref
  UsersType userData = UsersType(
      schoolId: 0,
      key: '',
      userName: '',
      lastName: '',
      middleInitial: '',
      userCourse: '',
      userYear: '',
      userPassword: '',
      isAdmin: false,
      userProfile: '',
      isSignupOnline: false,
      isLogin: false,
      eventAttended: '',
      isPenaltyShown: false,
      isValidationRep: false,
      isUserValidated: false);

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

  //101 - 150
  //validation representative
  List<int> validationIds = List<int>.generate(50, (index) => 101 + index);

  final String? secret_key = dotenv.env['secret_key'];

  //error code 1**

  //
  //GET
  //

  //101
  //offline
  getUsers() async {
    try {
      var users = await Supabase.instance.client.from('users').select('*');

      List<UsersType> usersListData = users.map((user) {
        return UsersType(
            schoolId: user['school_id'],
            key: user['key'],
            userName: user['username'],
            lastName: user['last_name'],
            middleInitial: user['middle_initial'],
            userCourse: user['user_course'],
            userYear: user['user_year'],
            userPassword: user['user_password'],
            isAdmin: user['is_admin'],
            userProfile: '',
            isSignupOnline: true,
            isLogin: user['is_login'],
            eventAttended: user['event_attended'],
            isValidationRep: user['validation_representative'],
            isPenaltyShown: false,
            isUserValidated: user['account_validated']);
      }).toList();

      userList = usersListData;
      notifyListeners();
      logger.t('fetch data successfully');
    } catch (e) {
      logger.e('error 101 fetching data $e');
      var data = userBox.values.toList();
      userList = data;
      notifyListeners();
    }
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
  Future<UsersType?> getUser(String id) async {
    // check if data  is already save in phone storage or already cache

    try {
      var user = await Supabase.instance.client
          .from('users')
          .select("*")
          .eq('school_id', int.parse(id))
          .single();

      userData = UsersType(
          schoolId: user['school_id'],
          key: user['key'],
          userName: user['username'],
          lastName: user['last_name'],
          middleInitial: user['middle_initial'],
          userCourse: user['user_course'],
          userYear: user['user_year'],
          userPassword: user['user_password'],
          isAdmin: user['is_admin'],
          userProfile: '',
          isSignupOnline: true,
          isLogin: user['is_login'],
          eventAttended: user['event_attended'],
          isValidationRep: user['validation_representative'],
          isPenaltyShown: false,
          isUserValidated: user["account_validated"]);

      logger.t('data $user');
      logger.t('successfully get user 103');
      notifyListeners();
      return userData;
    } catch (e) {
      logger.e('error 103 get user $e');
      //still works even offline
      var school_id = id == "" ? 0 : int.parse(id);
      UsersType? user = userBox.get(school_id);
      if (user != null) {
        userData = UsersType(
            schoolId: user.schoolId,
            key: user.key,
            userName: user.userName,
            lastName: user.lastName,
            middleInitial: user.middleInitial,
            userCourse: user.userCourse,
            userYear: user.userYear,
            userPassword: user.userPassword,
            isAdmin: user.isAdmin,
            userProfile: '',
            isSignupOnline: user.isSignupOnline,
            isLogin: user.isLogin,
            eventAttended: user.eventAttended,
            isValidationRep: user.isValidationRep,
            isPenaltyShown: false,
            isUserValidated: user.isUserValidated);
      }
      notifyListeners();
      return user;
    }
  }

  //104
  //get event specific user
  Future<bool> containsUser(int id) async {
    //api
    try {
      var user = await Supabase.instance.client.from('users').select("*");

      List<UsersType> users = user.map((eachUser) {
        return UsersType(
            schoolId: eachUser['school_id'],
            key: eachUser['key'],
            userName: eachUser['username'],
            lastName: eachUser['last_name'],
            middleInitial: eachUser['middle_initial'],
            userCourse: eachUser['user_course'],
            userYear: eachUser['user_year'],
            userPassword: eachUser['user_password'],
            isAdmin: eachUser['is_admin'],
            userProfile: '',
            isSignupOnline: true,
            isLogin: eachUser['is_login'],
            eventAttended: eachUser['event_attended'],
            isValidationRep: eachUser['validation_representative'],
            isPenaltyShown: false,
            isUserValidated: eachUser['account_validated']);
      }).toList();

      List filteredStudent =
          users.where((student) => student.schoolId == id).toList();

      bool isUserExist = filteredStudent.length == 1 ? true : false;

      logger.t('User exist 104 $isUserExist');

      return isUserExist;
    } catch (e) {
      logger.e('error 104 getting user $e');
      // encase offline
      var user = userBox.containsKey(id);
      return user;
    }
  }

  //105
  //get data for local image
  UsersType? getdataForlocalImage(int id) {
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
        logger.t('no image in database 106');
        return;
      }

      // user image
      final userImageUrl = await Supabase.instance.client.storage
          .from('profiles')
          .getPublicUrl(imagePath);

      userImage = userImageUrl.toString();
      notifyListeners();
      logger.t('successfully getting user image 106');
    } catch (e) {
      logger.e('error 106 getting user image');
      userImage = 'off';
      notifyListeners();
      return;
    }
  }

  getUserImageList() async {
    try {
      // check if there is imagepath in the list using id
      final urlResponse =
          await Supabase.instance.client.storage.from('profiles').list();

      List<String?> imagePathList =
          urlResponse.map((item) => item.name).toList();

      final imageUrlList = Map.fromEntries(imagePathList.map((element) {
        final image = Supabase.instance.client.storage
            .from('profiles')
            .getPublicUrl("${element}/image");

        return MapEntry(element, image);
      }));

      userImageList = imageUrlList;
    } catch (e) {
      logger.e("${e} get user image list");
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
        logger.t('no image in database');
        return;
      }

      final userImageUrl = await Supabase.instance.client.storage
          .from('profiles')
          .getPublicUrl(imagePath);

      userScannedImage = userImageUrl.toString();
      notifyListeners();
      logger.t('successfully getting scanned image 107');
    } catch (e) {
      logger.e('error 107 getting scanned image');
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
  createNewUser(
      String userName,
      String lastName,
      String middleInitial,
      int schoolId,
      String userCourse,
      String userYear,
      String userPassword,
      String userProfile) async {
    Cipher cipher = Cipher(secretKey: secret_key);
    //encryption
    final encryptedPassword = cipher.xorEncode(userPassword);
    bool isAdmin = false;
    bool isValidation = false;
    try {
      if (adminIds.contains(schoolId)) {
        isAdmin = true;
      }

      if (validationIds.contains(schoolId)) {
        isValidation = true;
      }
      await Supabase.instance.client.from('users').insert({
        'school_id': schoolId,
        'key': userName,
        'username': userName,
        'last_name': lastName,
        'middle_initial': middleInitial,
        'user_course': userCourse,
        'user_year': userYear,
        'user_password': encryptedPassword,
        'is_admin': isAdmin,
        'user_profile': userProfile,
        'is_login': false,
        'validation_representative': isValidation,
        'event_attended': '',
        'account_validated': false
      });

      userBox.put(
          schoolId,
          UsersType(
              schoolId: schoolId,
              key: userName,
              userName: userName,
              lastName: lastName,
              middleInitial: middleInitial,
              userCourse: userCourse,
              userYear: userYear,
              userPassword: encryptedPassword,
              isAdmin: isAdmin,
              userProfile: userProfile,
              isSignupOnline: true,
              isLogin: false,
              eventAttended: '',
              isValidationRep: isValidation,
              isPenaltyShown: false,
              isUserValidated: false));

      logger.t('data inserted successfully 108');
    } catch (e) {
      logger.e('error 108 insertion user $e');
      if (adminIds.contains(schoolId)) {
        isAdmin = true;
      }

      userBox.put(
          schoolId,
          UsersType(
              schoolId: schoolId,
              key: userName,
              userName: userName,
              lastName: lastName,
              middleInitial: middleInitial,
              userCourse: userCourse,
              userYear: userYear,
              userPassword: encryptedPassword,
              isAdmin: isAdmin,
              userProfile: userProfile,
              isSignupOnline: false,
              isLogin: false,
              eventAttended: '',
              isValidationRep: isValidation,
              isPenaltyShown: false,
              isUserValidated: false));
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
            lastName: user.lastName,
            middleInitial: user.middleInitial,
            userCourse: user.userCourse,
            userYear: user.userYear,
            userPassword: user.userPassword,
            isAdmin: user.isAdmin,
            userProfile: user.userProfile,
            isSignupOnline: user.isSignupOnline,
            isLogin: true,
            eventAttended: user.eventAttended,
            isValidationRep: user.isValidationRep,
            isPenaltyShown: false,
            isUserValidated: user.isUserValidated);

        notifyListeners();
        logger.t('successfully login user 109');
      });
    } catch (e) {
      logger.e('error 109 login user $e');
      //offline
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var data = userBox.get(id);

        if (data != null) {
          data.isLogin = true;
          userBox.put(id, data);

          userData = UsersType(
              schoolId: data.schoolId,
              key: data.key,
              userName: data.userName,
              lastName: data.lastName,
              middleInitial: data.middleInitial,
              userCourse: data.userCourse,
              userYear: data.userYear,
              userPassword: data.userPassword,
              isAdmin: data.isAdmin,
              userProfile: data.userProfile,
              isSignupOnline: data.isSignupOnline,
              isLogin: true,
              eventAttended: data.eventAttended,
              isValidationRep: data.isValidationRep,
              isPenaltyShown: false,
              isUserValidated: user.isUserValidated);
        }

        notifyListeners();
      });
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
          lastName: '',
          middleInitial: '',
          userCourse: '',
          userYear: '',
          userPassword: '',
          isAdmin: false,
          userProfile: '',
          isSignupOnline: false,
          isLogin: false,
          eventAttended: '',
          isPenaltyShown: false,
          isValidationRep: false,
          isUserValidated: false);

      userImage = '';
      logger.t("successfully Logout user 110");
      notifyListeners();
    } catch (e) {
      logger.e('error 110 logout user $e');
      var data = userBox.get(id);

      if (data != null) {
        data.isLogin = false;
        userBox.put(id, data);
      }

      userData = UsersType(
          schoolId: 0,
          key: '',
          userName: '',
          lastName: '',
          middleInitial: '',
          userCourse: '',
          userYear: '',
          userPassword: '',
          isAdmin: false,
          userProfile: '',
          isSignupOnline: false,
          isLogin: false,
          eventAttended: '',
          isPenaltyShown: false,
          isValidationRep: false,
          isUserValidated: false);

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

      logger.t('successfully updated event attended 111');
      return true;
    } catch (e) {
      return true;
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

  updateUserOfflineSaveData(int id) async {
    try {
      var users = await Supabase.instance.client
          .from('event_attendance_extras')
          .select("*");

      List<EventAttendance> allUsers = users.map((user) {
        return EventAttendance(
            id: user['id'],
            eventId: user['event_id'],
            officerName: user['officer_name'],
            studentId: user['student_id'],
            studentName: user['student_name'],
            studentCourse: user['student_course'],
            studentYear: user['student_year'],
            isDataSaveOffline: false);
      }).toList();

      List<EventAttendance> userEventAttended =
          allUsers.where((element) => element.studentId == id).toList();

      if (userEventAttended.isNotEmpty) {
        var getUserEventAttended = await Supabase.instance.client
            .from('users')
            .select("*")
            .eq("school_id", id)
            .single();

        String userAttended = getUserEventAttended['event_attended'];
        List<String> splitedEvent = userAttended.split("|");

        splitedEvent.remove("");
        List<int> unSaveAttendance = [];

        userEventAttended.forEach((element) {
          bool isAlreadyInList =
              unSaveAttendance.any((ids) => ids == element.eventId);
          if (!isAlreadyInList) {
            bool notExist =
                splitedEvent.any((ids) => int.parse(ids) == element.eventId);
            if (!notExist) {
              unSaveAttendance.add(element.eventId);
            }
          }
        });

        // update user attendance
        String fetchUserAttendance = unSaveAttendance.join("|");
        String formattedAttendance = "${userAttended}${fetchUserAttendance}|";

        String isfetchUserEmpty = fetchUserAttendance.length == 0
            ? userAttended
            : formattedAttendance;

        await Supabase.instance.client
            .from('users')
            .update({'event_attended': isfetchUserEmpty}).eq('school_id', id);

        //delete the data online
        await Supabase.instance.client
            .from('event_attendance_extras')
            .delete()
            .eq('student_id', id);
      }
    } catch (e) {
      logger.e('no internet');
    }
  }

  //get all admins and save in have
  getAllAdminsAndSave() async {
    try {
      var user = await Supabase.instance.client.from('users').select("*");

      List<UsersType> users = user.map((eachUser) {
        return UsersType(
            schoolId: eachUser['school_id'],
            key: eachUser['key'],
            userName: eachUser['username'],
            lastName: eachUser['last_name'],
            middleInitial: eachUser['middle_initial'],
            userCourse: eachUser['user_course'],
            userYear: eachUser['user_year'],
            userPassword: eachUser['user_password'],
            isAdmin: eachUser['is_admin'],
            userProfile: '',
            isSignupOnline: true,
            isLogin: eachUser['is_login'],
            isValidationRep: eachUser['validation_representative'],
            eventAttended: eachUser['event_attended'],
            isPenaltyShown: false,
            isUserValidated: eachUser['account_validated']);
      }).toList();

      // List<UsersType> allAdmins =
      //     users.where((element) => element.isAdmin == true).toList();

      Map<int, UsersType> allAdminsFormatted = {
        for (var user in users) user.schoolId: user
      };

      userBox.putAll(allAdminsFormatted);
    } catch (e) {
      logger.e('error no internet');
    }
  }

  userAccountValidated(int id) async {
    try {
      await Supabase.instance.client
          .from('users')
          .update({'account_validated': true}).eq('school_id', id);

      var data = userBox.get(id);

      if (data != null) {
        data.isUserValidated = true;
        userBox.put(id, data);
      }
      getUsers();
      notifyListeners();
    } catch (e) {
      var data = userBox.get(id);

      if (data != null) {
        data.isUserValidated = true;
        userBox.put(id, data);
      }
      notifyListeners();
    }
  }

  userAccountUnvalidated(int id) async {
    try {
      await Supabase.instance.client
          .from('users')
          .update({'account_validated': false}).eq('school_id', id);

      var data = userBox.get(id);

      if (data != null) {
        data.isUserValidated = false;
        userBox.put(id, data);
      }
      getUsers();
      notifyListeners();
    } catch (e) {
      var data = userBox.get(id);

      if (data != null) {
        data.isUserValidated = false;
        userBox.put(id, data);
      }
      notifyListeners();
    }
  }
}
