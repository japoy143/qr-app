import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/toast.dart';

class UpdateEventDialog extends StatefulWidget {
  final double screenHeight;
  final Color color;
  final double height;
  final double width;
  final TextEditingController eventNameController;
  final TextEditingController eventPlaceController;
  final TextEditingController eventDescription;
  final TextEditingController eventId;
  final TextEditingController eventPenalty;
  String currentDate;
  String currentTime;
  String eventTimeEnd;
  String lateTime;
  VoidCallback onSave;
  VoidCallback onCancel;
  final Function(String, String, String, String) onUpdateEventDetails;

  UpdateEventDialog(
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
      required this.onUpdateEventDetails,
      required this.screenHeight,
      required this.eventPenalty,
      required this.lateTime});

  @override
  State<UpdateEventDialog> createState() => _UpdateEventDialogState();
}

class _UpdateEventDialogState extends State<UpdateEventDialog> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentTime = DateTime.now();
  DateTime _eventEndTime = DateTime.now();
  DateTime _lateTime = DateTime.now();

  final toast = CustomToast();

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
      initialDateTime: DateTime.parse(widget.currentDate),
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
            _lateTime.toString(),
          );
          print(index);
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
            _lateTime.toString(),
          );
        });
        print(index);
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
                  widget.currentDate,
                  index.toString(),
                  widget.eventTimeEnd,
                  widget.lateTime,
                );
              });
              print(index);
            },
            onChange: (index) {
              setState(() {
                widget.currentTime = index.toString();
                _currentTime = index;
                widget.onUpdateEventDetails(
                  widget.currentDate,
                  index.toString(),
                  widget.eventTimeEnd,
                  widget.lateTime,
                );
              });
              print(index);
            },
            bottomPickerTheme: BottomPickerTheme.plumPlate,
            use24hFormat: false,
            initialTime: Time(
                hours: DateTime.parse(widget.currentTime).hour,
                minutes: DateTime.parse(widget.currentTime).minute))
        .show(context);
  }

  //late picker
  void lateTimePicker() {
    BottomPicker.time(
            pickerTitle: Text(
              'Set your late time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: widget.color,
              ),
            ),
            onSubmit: (index) {
              setState(() {
                widget.lateTime = index.toString();
                _lateTime = index;
                widget.onUpdateEventDetails(
                  widget.currentDate,
                  widget.currentTime,
                  widget.eventTimeEnd,
                  index.toString(),
                );
              });
              print(index);
            },
            onChange: (index) {
              setState(() {
                widget.lateTime = index.toString();
                _lateTime = index;
                widget.onUpdateEventDetails(
                  widget.currentDate,
                  widget.currentTime,
                  widget.eventTimeEnd,
                  index.toString(),
                );
              });
              print(index);
            },
            bottomPickerTheme: BottomPickerTheme.plumPlate,
            use24hFormat: false,
            initialTime: Time(
                hours: DateTime.parse(widget.lateTime).hour,
                minutes: DateTime.parse(widget.lateTime).minute))
        .show(context);
  }

  void timeEndPicker() {
    BottomPicker.time(
            pickerTitle: Text(
              'Set the event time end',
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
                  widget.currentDate,
                  widget.currentTime,
                  index.toString(),
                  widget.lateTime,
                );
              });
              print(index);
            },
            onChange: (index) {
              setState(() {
                widget.eventTimeEnd = index.toString();
                _eventEndTime = index;
                widget.onUpdateEventDetails(
                  widget.currentDate,
                  widget.currentTime,
                  index.toString(),
                  widget.lateTime,
                );
              });
              print(index);
            },
            bottomPickerTheme: BottomPickerTheme.plumPlate,
            use24hFormat: false,
            initialTime: Time(
                hours: DateTime.parse(widget.eventTimeEnd).hour,
                minutes: DateTime.parse(widget.eventTimeEnd).minute))
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMM dd').format(DateTime.parse(widget.currentDate));
    String formattedTime =
        DateFormat('h:mm a').format(DateTime.parse(widget.currentTime));
    String formattedEventEnd =
        DateFormat('h:mm a').format(DateTime.parse(widget.eventTimeEnd));
    String formattedLateTime =
        DateFormat('h:mm a').format(DateTime.parse(widget.lateTime));

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
                      height: widget.screenHeight,
                      isReadOnly: false,
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
                            height: widget.screenHeight,
                            isReadOnly: false,
                            hintext: 'description',
                            keyBoardType: TextInputType.text,
                            controller: widget.eventDescription),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: CustomTextField(
                            height: widget.screenHeight,
                            isReadOnly: true,
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Text(
                    'Make sure to set again the time',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Time'),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: widget.color),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Center(
                                        child: Text(
                                      formattedTime,
                                      style: const TextStyle(fontSize: 14.0),
                                    )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: timeStartPicker,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: widget.color,
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      child: const Center(
                                          child: Text(
                                        "Set",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End Time'),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: widget.color),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Center(
                                        child: Text(
                                      formattedEventEnd,
                                      style: const TextStyle(fontSize: 14.0),
                                    )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: timeEndPicker,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: widget.color,
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      child: const Center(
                                          child: Text(
                                        "Set",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ),
                Row(
                  children: [
                    //setter 1
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: Text('Event Date'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: widget.color),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Center(
                                      child: Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 16.0),
                                  )),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: datePicker,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: widget.color,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: const Center(
                                        child: Text(
                                      "Set",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    //setter 2
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: Text('Late Time'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: widget.color),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Center(
                                      child: Text(
                                    formattedLateTime,
                                    style: const TextStyle(fontSize: 14.0),
                                  )),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: lateTimePicker,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: widget.color,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: const Center(
                                        child: Text(
                                      "Set",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Where',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                                child: CustomTextField(
                                    height: widget.screenHeight,
                                    isReadOnly: false,
                                    hintext: 'enter event place',
                                    keyBoardType: TextInputType.text,
                                    controller: widget.eventPlaceController),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penalty',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 2),
                                  child: CustomTextField(
                                    height: widget.screenHeight,
                                    isReadOnly: false,
                                    hintext: '₱20',
                                    keyBoardType: TextInputType.number,
                                    controller: widget.eventPenalty,
                                  )),
                            ],
                          ))
                    ],
                  ),
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
