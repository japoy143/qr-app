import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/validationscreen/validationusers.dart';

class ValidationScreen extends StatefulWidget {
  final String userKey;
  const ValidationScreen({super.key, required this.userKey});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int totalEvent = 0;

  //color theme
  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    Provider.of<UsersProvider>(context, listen: false).getUserImageList();
    super.initState();
  }

  final appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        //users
        List<UsersType> allUsers = provider.userList;

        //sort user from admin, representative,  and  normal users
        List<UsersType> sortedUsers = allUsers
            .where((student) =>
                student.isAdmin == false && student.isValidationRep == false)
            .toList();

        //imageList
        final imageList = provider.userImageList;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Validation Accounts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'users validation account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade400,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: sortedUsers.length,
                        itemBuilder: (context, index) {
                          final item = sortedUsers.elementAt(index);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: ValidationUsers(
                                user: item,
                                imageList: imageList,
                              ),
                            ),
                          );
                        })),
              ],
            )),
          ),
        );
      },
    );
  }
}
