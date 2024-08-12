import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:uuid/uuid.dart';

class EventDatabase {
  var id = Uuid();
  late Box<EventType> _box;

  Box<EventType> EventDatabaseInitialization() {
    _box = Hive.box<EventType>('eventBox');

    return _box;
  }

  Future<void> UpdateEvent(int id) async {
    await EventDatabaseInitialization();

    //update only event ended
    var eventObject = _box.get(id);
    if (eventObject != null) {
      eventObject.eventEnded = true;
    }

    _box.put(id, eventObject!);
  }
}
