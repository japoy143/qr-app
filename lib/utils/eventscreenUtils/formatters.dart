import 'package:flutter/cupertino.dart';
import 'package:qr_app/utils/toast.dart';

class EventScreentFormatterUtils {
  final toast = CustomToast();

  DateTime dateFormmater(String current_date, String event_time) {
    List<String> splitCurrentDate = current_date.split(" ");

    List<String> splitEventTime = event_time.split(" ");

    String formattedDate =
        [splitCurrentDate[0], " ", splitEventTime[1]].join("");

    DateTime parseDate = DateTime.parse(formattedDate);

    return parseDate;
  }

  bool ensureEventTimeIsBeforeThanEventEnd(
      BuildContext context, String _eventTime, String _eventEnd) {
    if (_eventTime.length == 0 || _eventEnd.length == 0) {
      toast.errorEventTimeNotSet(context);
      return true;
    }

    DateTime timeStart = DateTime.parse(_eventTime);
    DateTime timeEnd = DateTime.parse(_eventEnd);

    if (timeStart.isAfter(timeEnd)) {
      toast.errorEventIdAlreadyUsed(context);
      return true;
    }

    return false;
  }
}
