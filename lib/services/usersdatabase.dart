import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/utils/toast.dart';
import 'package:uuid/uuid.dart';

class UsersDatabase {
  var id = Uuid();
  late Box<UsersType> _box;

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

  Box<UsersType> UsersDatabaseInitialization() {
    var key = id.v1();
    DateTime date = DateTime.now();
    _box = Hive.box<UsersType>('usersBox');

    if (_box.isEmpty) {
      _box.put(
          key,
          UsersType(
              schoolId: 20021,
              key: key,
              userName: 'Jose',
              userCourse: 'BSIT',
              userYear: '4',
              userPassword: 'Busman',
              isAdmin: false,
              userProfile: 'dada'));
    }

    return _box;
  }

  void createNewUser(String userName, int schoolId, String userCourse,
      String userYear, String userPassword, String userProfile) {
    bool isAdmin = false;

    if (adminIds.contains(schoolId)) {
      isAdmin = true;
    }

    _box.put(
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
}
