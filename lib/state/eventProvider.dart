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
    await eventBox.add(event);
    getEvents();
    notifyListeners();
  }

  updateEventEndedData(int id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the event object
      var eventObject = evenList.firstWhere((element) => element.id == id);

      // Update the eventEnded property
      eventObject.eventEnded = true;

      // Save the updated object back to the box
      eventBox.put(id, eventObject);

      // Refresh events and notify listeners
      getEvents();
      notifyListeners();
    });
  }

  updateEvent(int id, EventType eventType) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Find the correct Hive key for the event you want to update
      final keyToUpdate = eventBox.keys.firstWhere(
        (key) => eventBox.get(key)!.id == id, // Match the event's id field
        orElse: () => null, // Return null if no match is found
      );

      if (keyToUpdate != null) {
        // Save the updated object back to the box
        eventBox.put(keyToUpdate, eventType);

        // Refresh events and notify listeners
        getEvents();
        notifyListeners();
      } else {
        print('Event with id $id not found');
      }
    });
  }

  deleteEvent(int id) async {
    // Find the key corresponding to the event with the given id
    final keyToDelete = eventBox.keys.firstWhere(
      (key) => eventBox.get(key)!.id == id, // Match the event's id field
      orElse: () => null, // Return null if no match is found
    );

    if (keyToDelete != null) {
      await eventBox.delete(keyToDelete);
      getEvents();
      notifyListeners();
    } else {
      // Handle the case where the event with the specified id was not found
      print('Event with id $id not found');
    }
  }
}
