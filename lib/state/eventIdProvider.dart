import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/eventsid.dart';

class EventIdProvider extends ChangeNotifier {
  // create box
  var eventIdBox = Hive.box<EventsId>('eventsIdBox');
  List<EventsId> eventIdList = [];

  // event  length
  int eventLength = 0;

  //error code 4**

  //  401
  getEvents() async {
    var data = eventIdBox.values.toList();
    eventIdList = data;
  }

  // 402
  //get event specific event
  Future<bool> containsEventId(int id) async {
    try {
      var eventID = await Supabase.instance.client
          .from('event_id')
          .select("*")
          .eq('event_id', id)
          .maybeSingle();

      if (eventID == null) {
        // ID not found
        return false;
      }

      bool isEventId = eventID['event_id'] == id;
      print('get 402 , $isEventId');
      return isEventId;
    } catch (e) {
      print('402 error events id $e');
      var event = eventIdBox.containsKey(id);
      return event;
    }
  }

  //403
  //get the length
  getEventIdLength() async {
    try {
      var eventIds =
          await Supabase.instance.client.from('event_id').select('*');

      var length = eventIds.length;

      eventLength = eventIds.length;

      print('sucessfully 403 $length');
    } catch (e) {
      print('error 403 $e');
    }
  }

  //insert events
  insertData(int id, EventsId event) async {
    try {
      await Supabase.instance.client
          .from('event_id')
          .insert({'id': id, 'event_id': id});
      eventIdBox.put(id, event);
      getEvents();
      notifyListeners();
    } catch (e) {
      print('error $e');
      await eventIdBox.put(id, event);
      getEvents();
      notifyListeners();
    }
  }

  deleteEvent(int id) async {
    eventIdBox.delete(id);
    getEvents();
    notifyListeners();
  }
}
