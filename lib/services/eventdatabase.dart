import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:uuid/uuid.dart';

class EventDatabase {
  var id = Uuid();
  late Box<EventType> _box;

  Box<EventType> EventDatabaseInitialization() {
    var key = id.v1();
    _box = Hive.box<EventType>('eventsBox');

    if(_box.isEmpty){
      _box.put(key, EventType(id: key, eventName: eventName, eventDescription: eventDescription, eventDate: eventDate, startTime: startTime))
    }
  }
}
