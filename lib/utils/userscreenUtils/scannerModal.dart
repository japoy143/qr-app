import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/utils/toast.dart';

class ScannerModal extends StatefulWidget {
  final EventAttendance eventAttendance;
  final String userSchoolId;
  final int eventId;
  const ScannerModal(
      {super.key,
      required this.eventAttendance,
      required this.userSchoolId,
      required this.eventId});

  @override
  State<ScannerModal> createState() => _ScannerModalState();
}

class _ScannerModalState extends State<ScannerModal> {
  //toast
  final toast = CustomToast();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'User Validation Account',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19.0),
            ),
          ),
          Text(
              'Check student first if it is really the user for to validate attendance.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    toast.errorStudentNotSave(context);
                    Navigator.pop(context);
                    print('tapped');
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final eventAttendanceProvider =
                        Provider.of<EventAttendanceProvider>(context,
                            listen: false);
                    final userProvider =
                        Provider.of<UsersProvider>(context, listen: false);

                    eventAttendanceProvider.insertData(
                        widget.userSchoolId, widget.eventAttendance);

                    final isUserAttended =
                        await userProvider.updateUserNewAttendedEvent(
                            widget.eventId.toString(),
                            int.parse(widget.userSchoolId));

                    if (!isUserAttended) {
                      toast.errorStudentNotSave(context);
                      return;
                    }
                    //TODO: update user attendance
                    toast.AttendanceSuccessfullySave(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
