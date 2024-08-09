import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';

class EventProvider extends ChangeNotifier {
  Box<EventType>? _box;

  EventProvider() {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    _box = await Hive.box<EventType>('eventBox');
    notifyListeners(); // Notify listeners that the box has been initialized
  }

  // Method to get all events
  List<EventType> getAllEvents() {
    return _box?.values.toList() ?? [];
  }

  bool ContainsKey(int Id) {
    try {
      return _box!.containsKey(Id);
    } catch (e) {
      // Handle or log the error
      print('Failed to find event: $e');
      return false;
    }
  }

//Add an Event
  Future<void> AddEvent(int EventId, EventType eventType) async {
    await _box?.put(EventId, eventType);
    notifyListeners();
  }

//find Event
  EventType? FindEvent(int EventId) {
    return _box?.get(EventId);
  }

  //update
  Future<void> UpdateEvent(int EventId, EventType eventType) async {
    await _box?.put(EventId, eventType);
    notifyListeners();
  }

  //delete event
  Future<void> DeleteEvent(int EventId) async {
    await _box?.delete(EventId);
    notifyListeners();
  }
}
