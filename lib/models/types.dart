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
