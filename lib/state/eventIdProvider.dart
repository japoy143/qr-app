import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/eventsid.dart';

class EventIdProvider extends ChangeNotifier {
  // create box
  var eventIdBox = Hive.box<EventsId>('eventsIdBox');
  List<EventsId> eventIdList = [];

  getEvents() async {
    var data = eventIdBox.values.toList();
    eventIdList = data;
  }

  //get event specific event
  bool containsEventId(int id) {
    var event = eventIdBox.containsKey(id);
    return event;
  }

  //insert events
  insertData(int id, EventsId event) async {
    await eventIdBox.put(id, event);
    getEvents();
    notifyListeners();
  }

  // updateEventEndedData(int id) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Retrieve the event object
  //     var eventObject = eventIdBox.get(id);

  //     if (eventObject != null) {
  //       // Update the eventEnded property
  //       eventObject.eventEnded = true;
  //       eventIdBox.put(id, eventObject);
  //     }

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  // updateEvent(int id, EventType eventType) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Save the updated object back to the box
  //     eventIdBox.put(id, eventType);

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  deleteEvent(int id) async {
    eventIdBox.delete(id);
    getEvents();
    notifyListeners();
  }
}
