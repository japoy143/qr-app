import 'package:flutter/material.dart';
import 'package:qr_app/models/users.dart';

class ValidationUsers extends StatefulWidget {
  final UsersType user;
  final Map<String?, String> imageList;
  const ValidationUsers(
      {super.key, required this.user, required this.imageList});

  @override
  State<ValidationUsers> createState() => _ValidationUsersState();
}

class _ValidationUsersState extends State<ValidationUsers> {
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final image = widget.imageList;

    final imageUrl = image[user.schoolId.toString()];

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
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    decoration: checkBox
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              Checkbox(
                  value: checkBox,
                  onChanged: (e) {
                    setState(() {
                      checkBox = !checkBox;
                    });
                  }),
            ],
          ))
    ]);
  }
}
