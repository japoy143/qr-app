import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/notificationProvider.dart';
import 'package:qr_app/theme/colortheme.dart';

class NotificationScreen extends StatefulWidget {
  final double screenHeight;
  const NotificationScreen({super.key, required this.screenHeight});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final colortheme = ColorThemeProvider();

  //is message open or on read
  bool isMessageOpen = false;

  @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotifications();

    super.initState();
  }

  //date formatter
  String dateFormatter(String time) {
    DateTime convertStringTime = DateTime.parse(time);
    String monthAndDay = DateFormat('MMM d').format(convertStringTime);
    String hour = DateFormat('h:mm a').format(convertStringTime);
    String formattedDate = "$monthAndDay | $hour";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    // notications
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    //notification list
    final notificationList = notificationProvider.notificationList;

    //sort by  date
    notificationList.sort((a, b) => a.time.compareTo(b.time));

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 4),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Stay updated with your latest notifications',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade400,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
                flex: 9,
                child: Container(
                  child: ListView.builder(
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        //each notifcation
                        final item = notificationList.elementAt(index);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                item.isOpen = !item.isOpen;
                                item.read = true;
                              });
                              notificationProvider.updateMessageRead(item.id);
                            },
                            child: Slidable(
                              endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.redAccent,
                                      onPressed: (context) {
                                        setState(() {
                                          notificationProvider
                                              .deleteNotification(item.id);
                                        });
                                      },
                                      icon: Icons.delete,
                                      borderRadius: BorderRadius.circular(12.0),
                                    )
                                  ]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: !item.read
                                            ? purple
                                            : Colors.grey.shade400,
                                        width: 3)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    item.isOpen
                                        ? Text(item.subtitle,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15))
                                        : SizedBox.shrink(),
                                    item.isOpen
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(item.body,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                          )
                                        : SizedBox.shrink(),
                                    !item.isOpen
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(item.subtitle,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                              Text(dateFormatter(item.time),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14))
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(dateFormatter(item.time),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14))
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )),
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
                            width: 100,
                            decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: const Center(
                              child: Text(
                                'Back',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    )))
          ],
        )),
      ),
    );
  }
}
