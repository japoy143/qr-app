import 'package:hive/hive.dart';
import 'package:qr_app/models/eventsid.dart';

class EventIdDatabase {
  late Box<EventsId> _box;

  Box<EventsId> EventIdDatabaseInitialization() {
    _box = Hive.box<EventsId>('eventsIdBox');

    return _box;
  }


 
}
