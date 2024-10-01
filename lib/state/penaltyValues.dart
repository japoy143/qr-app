import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:qr_app/models/penaltyvalues.dart';

class PenaltyValuesProvider extends ChangeNotifier {
  //logger
  var logger = Logger();
  // create box
  var penaltyBox = Hive.box<PenaltyValues>('penaltyBox');
  List<PenaltyValues> penaltyList = [];

  List<PenaltyValues> penaltyEquivalent = [
    PenaltyValues(id: 1, penaltyvalue: " ", penaltyprice: 0, isOpen: false),
    PenaltyValues(
        id: 2,
        penaltyvalue: "1 Ballpen,1 Pencil",
        penaltyprice: 20,
        isOpen: false),
    PenaltyValues(
        id: 3,
        penaltyvalue: "2 Ballpen,2 Pencil",
        penaltyprice: 30,
        isOpen: false),
    PenaltyValues(
        id: 4,
        penaltyvalue: "1 Pad Paper,1 Crayons 8 colors",
        penaltyprice: 40,
        isOpen: false),
    PenaltyValues(
        id: 5,
        penaltyvalue: "1 Ballpen,1 Pencil,1 Crayons 8 colors,1 Pad Paper",
        penaltyprice: 50,
        isOpen: false),
    PenaltyValues(
        id: 6,
        penaltyvalue: "1 Pad Paper,1 Crayons 8 colors,1 Small Notebook",
        penaltyprice: 60,
        isOpen: false),
    PenaltyValues(
        id: 7,
        penaltyvalue: "1 Crayons 8 colors,1 Pad Paper,1 Small Notebook",
        isOpen: false,
        penaltyprice: 70),
    PenaltyValues(
        id: 8,
        penaltyvalue: "1 Ballpen,1 Pencil,1 Pad Paper,1 Big Notebook",
        penaltyprice: 80,
        isOpen: false),
    PenaltyValues(
        id: 9,
        penaltyvalue: "1 Big NoteBook,2 Small Notebook",
        penaltyprice: 90,
        isOpen: false),
    PenaltyValues(
        id: 10,
        penaltyvalue:
            "1 Crayons 8 colors,1 Pad Paper,1 Small Notebook,1 Big Notebook",
        penaltyprice: 100,
        isOpen: false),
  ];

  Map<int, PenaltyValues> pair = {
    1: PenaltyValues(id: 1, penaltyvalue: " ", penaltyprice: 0, isOpen: false),
    2: PenaltyValues(
        id: 2,
        penaltyvalue: "1 Ballpen,1 Pencil",
        penaltyprice: 20,
        isOpen: false),
    3: PenaltyValues(
        id: 3,
        penaltyvalue: "2 Ballpen,2 Pencil",
        penaltyprice: 30,
        isOpen: false),
    4: PenaltyValues(
        id: 4,
        penaltyvalue: "1 Pad Paper,1 Crayons 8 colors",
        penaltyprice: 40,
        isOpen: false),
    5: PenaltyValues(
        id: 5,
        penaltyvalue: "1 Ballpen,1 Pencil,1 Crayons 8 colors,1 Pad Paper",
        penaltyprice: 50,
        isOpen: false),
    6: PenaltyValues(
        id: 6,
        penaltyvalue: "1 Pad Paper,1 Crayons 8 colors,1 Small Notebook",
        penaltyprice: 60,
        isOpen: false),
    7: PenaltyValues(
        id: 7,
        penaltyvalue: "1 Crayons 8 colors,1 Pad Paper,1 Small Notebook",
        isOpen: false,
        penaltyprice: 70),
    8: PenaltyValues(
        id: 8,
        penaltyvalue: "1 Ballpen,1 Pencil,1 Pad Paper,1 Big Notebook",
        penaltyprice: 80,
        isOpen: false),
    9: PenaltyValues(
        id: 9,
        penaltyvalue: "1 Big NoteBook,2 Small Notebook",
        penaltyprice: 90,
        isOpen: false),
    10: PenaltyValues(
        id: 10,
        penaltyvalue:
            "1 Crayons 8 colors,1 Pad Paper,1 Small Notebook,1 Big Notebook",
        penaltyprice: 100,
        isOpen: false),
  };

  // List<PenaltyValues> penaltyEquivalent = [
  //   PenaltyValues(id: 1, penaltyvalue: " ", penaltyprice: 0),
  //   PenaltyValues(id: 2, penaltyvalue: " ", penaltyprice: 20),
  //   PenaltyValues(id: 3, penaltyvalue: " ", penaltyprice: 30),
  //   PenaltyValues(id: 4, penaltyvalue: "", penaltyprice: 40),
  //   PenaltyValues(id: 5, penaltyvalue: " ", penaltyprice: 50),
  //   PenaltyValues(id: 6, penaltyvalue: " ", penaltyprice: 60),
  //   PenaltyValues(id: 7, penaltyvalue: " ", penaltyprice: 70),
  //   PenaltyValues(id: 8, penaltyvalue: " ", penaltyprice: 80),
  //   PenaltyValues(id: 9, penaltyvalue: " ", penaltyprice: 90),
  //   PenaltyValues(id: 10, penaltyvalue: " ", penaltyprice: 100),
  // ];

// init
  penaltyInit() {
    if (penaltyBox.isEmpty) {
      penaltyBox.putAll(pair);
    }
  }

  //error code 3**

  //301
  getPenaltyValues() async {
    try {
      var data = penaltyBox.values.toList();
      penaltyList = data;

      logger.t('penalty successfully get penalty list 001');
    } catch (e) {
      logger.e("penalty error ${e} 001");
    }
  }

  updatePenaltyPrice(int id, PenaltyValues penalty) {
    try {
      penaltyBox.put(
          id,
          PenaltyValues(
              id: id,
              penaltyvalue: penalty.penaltyvalue,
              penaltyprice: penalty.penaltyprice,
              isOpen: penalty.isOpen));

      getPenaltyValues();
      notifyListeners();
    } catch (e) {}
  }

  updatePenaltyEquivalent(int id, PenaltyValues penalty) {
    try {
      penaltyBox.put(
          id,
          PenaltyValues(
              id: id,
              penaltyvalue: penalty.penaltyvalue,
              penaltyprice: penalty.penaltyprice,
              isOpen: penalty.isOpen));
      getPenaltyValues();
      notifyListeners();
    } catch (e) {}
  }

  // //302
  // //get event specific event
  // Future<bool> containsStudent(int eventId, int id) async {
  //   try {
  //     var user =
  //         await Supabase.instance.client.from('event_attendance').select("*");

  //     //get all event attendance
  //     List<EventAttendance> userAttendedList = user.map((attendance) {
  //       return EventAttendance(
  //           id: attendance['id'],
  //           eventId: attendance['event_id'],
  //           officerName: attendance['officer_name'],
  //           studentId: attendance['student_id'],
  //           studentName: attendance['student_name'],
  //           studentCourse: attendance['student_course'],
  //           studentYear: attendance['student_year'],
  //           isDataSaveOffline: false);
  //     }).toList();

  //     //get the student with the same event id
  //     List filteredAttended = userAttendedList
  //         .where((student) =>
  //             student.eventId == eventId && student.studentId == id)
  //         .toList();

  //     print(filteredAttended.length);
  //     if (filteredAttended.isEmpty) {
  //       return false;
  //     }

  //     logger.t('successfully find user 302');
  //     return true;
  //   } catch (e) {
  //     logger.e('error 302 event Attendance $e');

  //     List<EventAttendance> allEvents = eventAttendanceBox.values.toList();

  //     List filteredAttend = allEvents
  //         .where(
  //             (student) => student.eventId == eventId && student.eventId == id)
  //         .toList();

  //     if (filteredAttend.isEmpty) {
  //       return false;
  //     }

  //     return true;
  //   }
  // }

  // //TODO:here problem
  // //303
  // //insert event attendance
  // insertData(String userSchoolId, EventAttendance event) async {
  //   try {
  //     await Supabase.instance.client.from('event_attendance').insert({
  //       'event_id': event.eventId,
  //       'student_id': event.studentId,
  //       'student_name': event.studentName,
  //       'officer_name': event.officerName,
  //       'student_course': event.studentCourse,
  //       'student_year': event.studentYear,
  //     });

  //     EventAttendance eventData = EventAttendance(
  //         id: event.id,
  //         eventId: event.eventId,
  //         officerName: event.officerName,
  //         studentId: event.studentId,
  //         studentName: event.studentName,
  //         studentCourse: event.studentCourse,
  //         studentYear: event.studentYear,
  //         isDataSaveOffline: true);

  //     await eventAttendanceBox.put(userSchoolId, eventData);
  //     getEventAttendance();
  //     notifyListeners();
  //     logger.t('successfully 303 added event Attendance');
  //   } catch (e) {
  //     logger.e('error 303 event Attendance  $e');

  //     EventAttendance eventData = EventAttendance(
  //         id: event.id,
  //         eventId: event.eventId,
  //         officerName: event.officerName,
  //         studentId: event.studentId,
  //         studentName: event.studentName,
  //         studentCourse: event.studentCourse,
  //         studentYear: event.studentYear,
  //         isDataSaveOffline: true);

  //     int badger = int.parse('${event.id}${event.studentId}');

  //     eventAttendanceBox.add(eventData);
  //     getEventAttendance();
  //     notifyListeners();
  //   }
  // }

  // //304
  // deleteEvent(int id) async {
  //   eventAttendanceBox.delete(id);
  //   getEventAttendance();
  //   notifyListeners();
  //   logger.t('successfully deleted eventAttendance');
  // }

  // getOfflineSaveEventAttendance() async {
  //   var allEventAttendance = eventAttendanceBox.values.toList();

  //   List<EventAttendance> filteredOffline = allEventAttendance
  //       .where((element) => element.isDataSaveOffline == true)
  //       .toList();

  //   logger.e(filteredOffline.length);

  //   var data = filteredOffline.map((ids) {
  //     return {
  //       'event_id': ids.eventId,
  //       'student_id': ids.studentId,
  //       'student_name': ids.studentName,
  //       'officer_name': ids.officerName,
  //       'student_course': ids.studentCourse,
  //       'student_year': ids.studentYear
  //     };
  //   }).toList();

  //   data.forEach((element) {
  //     logger.e('${element}   event attendance');
  //   });

  //   try {
  //     await Supabase.instance.client
  //         .from('event_attendance_extras')
  //         .insert(data);
  //   } catch (e) {
  //     logger.e('error $e savig offline data');
  //   }
  // }
}
