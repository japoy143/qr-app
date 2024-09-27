import 'package:flutter/material.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/utils/validationscreen/updateDialog.dart';

class ValidationUsers extends StatefulWidget {
  final UsersType user;
  final Map<String?, String> imageList;
  const ValidationUsers(
      {super.key, required this.user, required this.imageList});

  @override
  State<ValidationUsers> createState() => _ValidationUsersState();
}

class _ValidationUsersState extends State<ValidationUsers> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final image = widget.imageList;

    final imageUrl = image[user.schoolId.toString()];
    bool checkBox = user.isUserValidated;
    //dialog
    showValidationDialog(int id) {
      showDialog(
          context: context,
          builder: (context) {
            return UpdateValidationDialog(
              id: id,
              checkboxTrue: () {
                setState(() {
                  checkBox = true;
                });
              },
              checkboxfalse: () {
                setState(() {
                  checkBox = false;
                });
              },
            );
          });
    }

    return Row(children: [
      Expanded(
        flex: 1,
        child: imageUrl != null
            ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    imageUrl), // Use NetworkImage for URL-based images
                backgroundColor: Colors.transparent,
              )
            : Icon(
                Icons.account_circle_outlined,
                size: 60,
              ),
      ),
      Expanded(
          flex: 2,
          child: Text(
            "${user.userName} ${user.middleInitial}. ${user.lastName}\n${user.userCourse}-${user.userYear}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: checkBox
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          )),
      Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Not Validated",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: checkBox
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              Checkbox(
                  value: checkBox,
                  onChanged: (e) {
                    setState(() {
                      showValidationDialog(user.schoolId);
                      checkBox = !checkBox;
                    });
                  }),
            ],
          ))
    ]);
  }
}
