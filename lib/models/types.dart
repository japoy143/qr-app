// courses penalty type
class CoursesEventType {
  String courseName;
  int eventAttended;

  CoursesEventType({required this.courseName, required this.eventAttended});
}

class CoursesSummaryType {
  String courseName;
  int firstYear;
  int secondYear;
  int thirdYear;
  int fourthYear;
  int totalAttended;

  CoursesSummaryType({
    required this.courseName,
    required this.firstYear,
    required this.secondYear,
    required this.thirdYear,
    required this.fourthYear,
    required this.totalAttended,
  });
}

class EventListAttendanceType {
  int eventId;
  int officerId;
  String officerName;
  int studentId;
  String studentName;
  String studentCourse;
  String studentYear;

  EventListAttendanceType(
      {required this.eventId,
      required this.officerId,
      required this.officerName,
      required this.studentId,
      required this.studentName,
      required this.studentCourse,
      required this.studentYear});
}

class adminPositions {
  Map<dynamic, String> positions = {
    100001: "Governor",
    200002: "Vice Governor",
    300003: "Secretary",
    400004: "Treasurer",
    500005: "Representative",
    600006: "Representative",
    700007: "Representative",
    800008: "Representative",
    900009: "Faculty",
  };
}
