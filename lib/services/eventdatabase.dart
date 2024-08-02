import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:uuid/uuid.dart';

class EventDatabase {
  var id = Uuid();
  late Box<EventType> _box;

  Box<EventType> EventDatabaseInitialization() {
    _box = Hive.box<EventType>('_eventBox');

    return _box;
  }
}
