import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventProvider extends ChangeNotifier {
  // create box
  var eventBox = Hive.box<EventType>('eventBox');
  List<EventType> eventList = [];

//
//LISTENER
//

  callBackListener() {
    try {
      Supabase.instance.client
          .from('event')
          .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
        var events = data.map((event) {
          return EventType(
              id: event['event_id'],
              eventName: event['event_name'],
              eventDescription: event['event_description'],
              eventDate: DateTime.parse(event['event_date']),
              startTime: DateTime.parse(event['start_time']),
              endTime: DateTime.parse(event['end_time']),
              eventEnded: event['event_ended'],
              eventPlace: event['event_place'],
              eventStatus: '',
              key: event['key']);
        }).toList();

        eventList = events;
        print('callback');
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

//
//GET
//
  getEvents() async {
    try {
      var events = await Supabase.instance.client.from('event').select("*");

      List<EventType> allEvents = events.map((event) {
        return EventType(
            id: event['event_id'],
            eventName: event['event_name'],
            eventDescription: event['event_description'],
            eventDate: DateTime.parse(event['event_date']),
            startTime: DateTime.parse(event['start_time']),
            endTime: DateTime.parse(event['end_time']),
            eventEnded: event['event_ended'],
            eventPlace: event['event_place'],
            eventStatus: '',
            key: event['key']);
      }).toList();

      eventList = allEvents;
      notifyListeners();
      print('successfully get');
    } catch (e) {
      var data = eventBox.values.toList();
      eventList = data;
      notifyListeners();
    }
  }

  //get event specific event
  bool containsEvent(int id) {
    var event = eventBox.containsKey(id);
    return event;
  }

//
//INSERT
//

  //insert events
  insertData(EventType event) async {
    try {
      await Supabase.instance.client.from('event').insert({
        'event_id': event.id,
        'event_name': event.eventName,
        'event_description': event.eventDescription,
        'event_date': event.eventDate.toString(),
        'start_time': event.startTime.toString(),
        'event_status': '',
        'key': event.id.toString(),
        'event_place': event.eventPlace,
        'end_time': event.endTime.toString(),
        'event_ended': event.eventEnded
      });

      await eventBox.put(event.id, event);
      getEvents();
      notifyListeners();
    } catch (e) {
      await eventBox.put(event.id, event);
      getEvents();
      notifyListeners();
      print(e);
    }
  }

//
//UPDATE
//

  updateEventEndedData(int id) async {
    try {
      await Supabase.instance.client
          .from('event')
          .update({'event_ended': true}).eq('event_id', id);

      var eventObject = eventBox.get(id);

      if (eventObject != null) {
        // Update the eventEnded property
        eventObject.eventEnded = true;
        eventBox.put(id, eventObject);
      }

      // Refresh events and notify listeners
      getEvents();
      notifyListeners();
    } catch (e) {
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
  }

  updateEvent(int id, EventType eventType) async {
    try {
      await Supabase.instance.client.from('event').update({
        'event_name': eventType.eventName,
        'event_description': eventType.eventDescription,
        'event_date': eventType.eventDate.toString(),
        'start_time': eventType.startTime.toString(),
        'event_status': '',
        'key': eventType.key,
        'event_place': eventType.eventPlace,
        'end_time': eventType.endTime.toString(),
        'event_ended': eventType.eventEnded
      }).eq('event_id', id);

      print('successfully updated');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Save the updated object back to the box
        eventBox.put(id, eventType);

        // Refresh events and notify listeners
        getEvents();
        notifyListeners();
      });
    } catch (e) {
      print('error update $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Save the updated object back to the box
        eventBox.put(id, eventType);

        // Refresh events and notify listeners
        getEvents();
        notifyListeners();
      });
    }
  }

  //
  //DELETE
  //

  deleteEvent(int id) async {
    try {
      await Supabase.instance.client.from('event').delete().eq('event_id', id);

      eventBox.delete(id);
      getEvents();
      notifyListeners();
    } catch (e) {
      eventBox.delete(id);
      getEvents();
      notifyListeners();
    }
  }
}
