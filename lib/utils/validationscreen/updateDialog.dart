import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/usersProvider.dart';

class UpdateValidationDialog extends StatefulWidget {
  final VoidCallback checkboxTrue;
  final VoidCallback checkboxfalse;
  final int id;
  const UpdateValidationDialog(
      {super.key,
      required this.id,
      required this.checkboxTrue,
      required this.checkboxfalse});

  @override
  State<UpdateValidationDialog> createState() => _UpdateValidationDialogState();
}

class _UpdateValidationDialogState extends State<UpdateValidationDialog> {
  //change user account status to validated
  validate() {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    provider.userAccountValidated(widget.id);
    widget.checkboxTrue();
    Navigator.of(context).pop();
  }

  //change user account status to unvalidated
  unvalidate() {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    provider.userAccountUnvalidated(widget.id);
    widget.checkboxfalse();
    provider.getUsers();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            Text(
              'Validate user account',
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            Text(
              'Validate user account status, update user account validate or unvalidate.',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: unvalidate,
                  child: Text(
                    'Unvalidate',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: validate,
                  child: Text(
                    'Validate',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
