import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/usersProvider.dart';

class deleteValidationDialog extends StatefulWidget {
  final int id;
  final String account;
  const deleteValidationDialog(
      {super.key, required this.id, required this.account});

  @override
  State<deleteValidationDialog> createState() => _deleteValidationDialogState();
}

class _deleteValidationDialogState extends State<deleteValidationDialog> {
  //change user account status to validated
  validate() {
    Provider.of<UsersProvider>(context, listen: false)
        .deleteUserAccount(widget.id);

    Navigator.of(context).pop();
  }

  //change user account status to unvalidated
  cancel() {
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
              'Delete user account',
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            Text(
              'Are you sure you want to delete ${widget.account} account .',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: cancel,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: validate,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w600),
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
