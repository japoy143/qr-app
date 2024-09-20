import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/eventsid.dart';

class EventIdProvider extends ChangeNotifier {
  //logger
  var logger = Logger();
  // create box
  var eventIdBox = Hive.box<EventsId>('eventsIdBox');
  var offlineBox = Hive.box('offlineBox');
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
      logger.t('get 402 , $isEventId');
      return isEventId;
    } catch (e) {
      logger.e('402 error events id $e');

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

      logger.t('sucessfully 403 $length');
    } catch (e) {
      logger.e('error 403 $e');
    }
  }

  //404
  //insert events
  insertData(int id, EventsId event) async {
    try {
      await Supabase.instance.client
          .from('event_id')
          .insert({'id': id, 'event_id': id});
      eventIdBox.put(id, event);
      getEvents();
      notifyListeners();
      logger.t('successfully inserted id');
    } catch (e) {
      logger.e('error $e');
      EventsId eventIdsData =
          EventsId(eventID: event.eventID, isDataSaveOffline: true);

      eventIdBox.put(id, eventIdsData);
      getEvents();
      notifyListeners();
    }
  }

  deleteEvent(int id) async {
    eventIdBox.delete(id);
    getEvents();
    notifyListeners();
  }

  getOfflineSaveEventId() async {
    var allEventIds = eventIdBox.values.toList();

    List<EventsId> filteredOfflineSaveData =
        allEventIds.where((ids) => ids.isDataSaveOffline == true).toList();

    var data = filteredOfflineSaveData.map((ids) {
      return {'id': ids.eventID, 'event_id': ids.eventID};
    }).toList();

    try {
      await Supabase.instance.client.from('event_id_extras').insert(data);
      print('offline data saved');
    } catch (e) {
      logger.e('error offline data $e');
    }

    offlineBox.put('offline', false);
  }

  saveEventIdExtras() async {
    var allEventIds =
        await Supabase.instance.client.from('event_id').select("*");

    List<EventsId> eventIdsList = allEventIds.map((ids) {
      return EventsId(eventID: ids['event_id'], isDataSaveOffline: false);
    }).toList();

    var eventIdExtras =
        await Supabase.instance.client.from('event_id_extras').select("*");

    List<EventsId> eventIdsExtrasList = eventIdExtras.map((ids) {
      return EventsId(eventID: ids['event_id'], isDataSaveOffline: false);
    }).toList();

    List unsave = [];

    eventIdsExtrasList.forEach((ids) {
      bool isIdAlreadySave =
          eventIdsList.any((element) => element.eventID == ids.eventID);

      if (!isIdAlreadySave) {
        unsave.add(ids.eventID);
      }
    });

    var formattedData = unsave.map((ids) {
      return {"event_id": ids};
    }).toList();

    await Supabase.instance.client.from('event_id').insert(formattedData);

    await Supabase.instance.client
        .from('event_id_extras')
        .delete()
        .inFilter('event_id', unsave);
  }
}
