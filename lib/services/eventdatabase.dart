import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:uuid/uuid.dart';

class EventDatabase {
  var id = Uuid();
  late Box<EventType> _box;

  Box<EventType> EventDatabaseInitialization() {
    var key = id.v1();
    DateTime date = DateTime.now();
    _box = Hive.box<EventType>('_eventBox');

    if (_box.isEmpty) {
      _box.put(
          key,
          EventType(
              id: 2001,
              eventName: "Drug Awareness Symposium",
              eventDescription:
                  'A seminar on awareness and prevention of illegal drugs',
              eventDate: date,
              startTime: date,
              endTime: date,
              key: key,
              eventPlace: 'Gym',
              eventStatus: 'Ongoing'));
    }

    return _box;
  }
}
