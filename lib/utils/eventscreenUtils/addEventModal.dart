import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/utils/eventscreenUtils/datePicker.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class addEventDialog extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final TextEditingController eventNameController;
  final TextEditingController eventPlaceController;
  final TextEditingController eventDescription;
  final TextEditingController eventId;
  String currentDate;
  String currentTime;
  String eventTimeEnd;
  VoidCallback onSave;
  VoidCallback onCancel;
  final Function(String, String, String) onUpdateEventDetails;

  addEventDialog(
      {super.key,
      required this.color,
      required this.height,
      required this.width,
      required this.eventNameController,
      required this.eventDescription,
      required this.onSave,
      required this.onCancel,
      required this.currentDate,
      required this.currentTime,
      required this.eventPlaceController,
      required this.eventId,
      required this.eventTimeEnd,
      required this.onUpdateEventDetails});

  @override
  State<addEventDialog> createState() => _addEventDialogState();
}

class _addEventDialogState extends State<addEventDialog> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentTime = DateTime.now();
  DateTime _eventEndTime = DateTime.now();
  void datePicker() {
    BottomPicker.date(
      pickerTitle: Text(
        'Set Event Date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: widget.color,
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: DateTime.now(),
      pickerTextStyle: TextStyle(
        color: widget.color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      onChange: (index) {
        setState(() {
          widget.currentDate = index.toString();
          _currentDate = index;

          widget.onUpdateEventDetails(
            index.toString(),
            _currentTime.toString(),
            _eventEndTime.toString(),
          );
        });
      },
      onSubmit: (index) {
        setState(() {
          widget.currentDate = index.toString();
          _currentDate = index;
          widget.onUpdateEventDetails(
            index.toString(),
            _currentTime.toString(),
            _eventEndTime.toString(),
          );
        });
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  void timeStartPicker() {
    BottomPicker.time(
      pickerTitle: Text(
        'Set your next meeting time',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: widget.color,
        ),
      ),
      onSubmit: (index) {
        setState(() {
          widget.currentTime = index.toString();
          _currentTime = index;
          widget.onUpdateEventDetails(
            _currentDate.toString(),
            index.toString(),
            _eventEndTime.toString(),
          );
        });
      },
      onChange: (index) {
        setState(() {
          widget.currentTime = index.toString();
          _currentTime = index;
          widget.onUpdateEventDetails(
            _currentDate.toString(),
            index.toString(),
            _eventEndTime.toString(),
          );
        });
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      use24hFormat: false,
      initialTime: Time(
        minutes: 10,
      ),
    ).show(context);
  }

  void timeEndPicker() {
    BottomPicker.time(
      pickerTitle: Text(
        'Set your next meeting time',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: widget.color,
        ),
      ),
      onSubmit: (index) {
        setState(() {
          widget.eventTimeEnd = index.toString();
          _eventEndTime = index;
          widget.onUpdateEventDetails(
            _currentDate.toString(),
            _currentTime.toString(),
            index.toString(),
          );
        });
      },
      onChange: (index) {
        setState(() {
          widget.eventTimeEnd = index.toString();
          _eventEndTime = index;
          widget.onUpdateEventDetails(
            _currentDate.toString(),
            _currentTime.toString(),
            index.toString(),
          );
        });
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      use24hFormat: false,
      initialTime: Time(
        minutes: 10,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd').format(_currentDate);
    String formattedTime = DateFormat('h:mm a').format(_currentTime);
    String formattedEventEnd = DateFormat('h:mm a').format(_eventEndTime);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: SizedBox(
            height: widget.height,
            width: widget.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 2),
                  child: CustomTextField(
                      hintext: 'enter event name',
                      keyBoardType: TextInputType.text,
                      controller: widget.eventNameController),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            hintext: 'description',
                            keyBoardType: TextInputType.text,
                            controller: widget.eventDescription),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: CustomTextField(
                            hintext: 'event id',
                            keyBoardType: TextInputType.number,
                            controller: widget.eventId),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'When',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Time'),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: widget.color),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Center(
                                    child: Text(
                                  formattedTime,
                                  style: const TextStyle(fontSize: 14.0),
                                )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: timeStartPicker,
                                child: Container(
                                  height: 40,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      color: widget.color,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: const Center(
                                      child: Text(
                                    "Set",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End Time'),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: widget.color),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Center(
                                    child: Text(
                                  formattedEventEnd,
                                  style: const TextStyle(fontSize: 14.0),
                                )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: timeEndPicker,
                                child: Container(
                                  height: 40,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      color: widget.color,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: const Center(
                                      child: Text(
                                    "Set",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                  child: Text('Event Date'),
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: widget.color),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Center(
                          child: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 16.0),
                      )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: datePicker,
                      child: Container(
                        height: 40,
                        width: 55,
                        decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: const Center(
                            child: Text(
                          "Set",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 2),
                  child: Text(
                    'Where',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                  child: CustomTextField(
                      hintext: 'enter event place',
                      keyBoardType: TextInputType.text,
                      controller: widget.eventPlaceController),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onCancel,
                        child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: widget.onSave,
                        child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: const Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
