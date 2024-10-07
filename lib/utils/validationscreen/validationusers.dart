import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/utils/validationscreen/updateDialog.dart';

class ValidationUsers extends StatefulWidget {
  final UsersType user;
  final Map<String?, String> imageList;
  final bool isOpen;
  const ValidationUsers(
      {super.key,
      required this.user,
      required this.imageList,
      required this.isOpen});

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

    final String? secret_key = dotenv.env['secret_key'];
    Cipher cipher = Cipher(secretKey: secret_key);
    final decryptedPassword = cipher.xorDecode(user.userPassword);

    return Column(children: [
      Row(
        children: [
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.userName} ${user.middleInitial}. ${user.lastName}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: checkBox
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                    maxLines: 1, // Limit the number of lines displayed
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${user.userCourse}-${user.userYear} id:${user.schoolId}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: checkBox
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                    maxLines: 1, // Limit the number of lines displayed
                    overflow: TextOverflow.ellipsis,
                  )
                ],
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
                        });
                      }),
                ],
              ))
        ],
      ),
      widget.isOpen
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Password:${decryptedPassword}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: checkBox
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      maxLines: 1, // Limit the number of lines displayed
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        Provider.of<UsersProvider>(context, listen: false)
                            .deleteUserAccount(user.schoolId);
                      },
                      child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                    )),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    ]);
  }
}
