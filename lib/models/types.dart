// courses penalty type
class CoursesEventType {
  String courseName;
  int eventAttended;

  CoursesEventType(
      {required this.courseName, required this.eventAttended});
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
    300003: "Business Manager",
    400004: "Treasurer",
    500005: "Officer",
    600006: "Officer",
    700007: "Officer",
    800008: "Officer",
    900009: "Officer",
  };
}
