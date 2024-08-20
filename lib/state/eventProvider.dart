import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';

class EventProvider extends ChangeNotifier {
  // create box
  var eventBox = Hive.box<EventType>('eventBox');
  List<EventType> evenList = [];

  getEvents() async {
    var data = eventBox.values.toList();
    evenList = data;
  }

  //insert events
  insertData(EventType event) async {
    await eventBox.put(event.id, event);
    getEvents();
    notifyListeners();
  }

  updateEventEndedData(int id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the event object
      var eventObject = eventBox.get(id);

      if (eventObject != null) {
        // Update the eventEnded property
        eventObject.eventEnded = true;
        eventBox.put(id, eventObject);
      }

      // Refresh events and notify listeners
      getEvents();
      notifyListeners();
    });
  }

  updateEvent(int id, EventType eventType) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Save the updated object back to the box
      eventBox.put(id, eventType);

      // Refresh events and notify listeners
      getEvents();
      notifyListeners();
    });
  }

  deleteEvent(int id) async {
    eventBox.delete(id);
    getEvents();
    notifyListeners();
  }
}
