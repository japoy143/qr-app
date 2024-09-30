import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:qr_app/models/events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventProvider extends ChangeNotifier {
  //logger
  var logger = Logger();
  // create box
  var eventBox = Hive.box<EventType>('eventBox');
  List<EventType> eventList = [];

  //error code 2**

//
//LISTENER
//

  //201
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
              eventPenalty: event['event_penalty'],
              key: event['key']);
        }).toList();

        eventList = events;
        logger.t('callback 201');
        notifyListeners();
      });
    } catch (e) {
      logger.e('error 201 event $e');
    }
  }

//
//GET
//
  //202
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
            eventPenalty: event['event_penalty'],
            key: event['key']);
      }).toList();

      Map<int, EventType> allEventFormatted = {
        for (var event in allEvents) event.id: event
      };

      eventBox.putAll(allEventFormatted);

      eventList = allEvents;
      notifyListeners();
      logger.t('successfully get event 202');
    } catch (e) {
      logger.e('error 202 getting event $e');
      var data = eventBox.values.toList();
      eventList = data;
      notifyListeners();
    }
  }

  //203
  filteredEventEnded() async {
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
            eventPenalty: event['event_penalty'],
            key: event['key']);
      }).toList();

      List<EventType> filteredEvent =
          allEvents.where((event) => event.eventEnded == true).toList();

      eventList = filteredEvent;
      notifyListeners();
      logger.t('successfully get event 203');
    } catch (e) {
      logger.e('error 203 getting event $e');
      var data = eventBox.values.toList();
      List<EventType> filteredEvent =
          data.where((event) => event.eventEnded == true).toList();
      eventList = filteredEvent;
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

  //204
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
        'event_ended': event.eventEnded,
        'event_penalty': event.eventPenalty
      });

      await eventBox.put(event.id, event);
      getEvents();
      notifyListeners();
      logger.t('successfully inserted event 204');
    } catch (e) {
      logger.e('error 204 insertion event $e');
      await eventBox.put(event.id, event);
      getEvents();
      notifyListeners();
    }
  }

//
//UPDATE
//

  //205
  updateEventEndedData(int id) async {
    try {
      //get status to check if already updated
      var event = await Supabase.instance.client
          .from('event')
          .select("*")
          .eq('event_id', id)
          .single();

      bool isEventAlreadyUpdated = event['event_ended'];

      if (isEventAlreadyUpdated) {
        filteredEventEnded();
        notifyListeners();
        logger.t('event already updated');
        return;
      }

      await Supabase.instance.client
          .from('event')
          .update({'event_ended': true}).eq('event_id', id);
      filteredEventEnded();
      logger.t('successfully updated event 205');
      notifyListeners();
    } catch (e) {
      logger.e('error 205 update event $e');
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

  //206
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

      logger.t('successfully updated event 206');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Save the updated object back to the box
        eventBox.put(id, eventType);

        // Refresh events and notify listeners
        getEvents();
        notifyListeners();
      });
    } catch (e) {
      logger.e('error 206 update event $e');
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

  //207
  deleteEvent(int id) async {
    try {
      await Supabase.instance.client.from('event').delete().eq('event_id', id);

      eventBox.delete(id);
      getEvents();
      notifyListeners();
      logger.t('successfully delete event 207');
    } catch (e) {
      logger.e('error 207 delete event $e');
      eventBox.delete(id);
      getEvents();
      notifyListeners();
    }
  }
}
