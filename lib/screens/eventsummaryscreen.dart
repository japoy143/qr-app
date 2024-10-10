import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/penaltyValues.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/coursesSummary.dart';
import 'package:qr_app/utils/eventsummaryUtils/eventsummarybox.dart';
import 'package:qr_app/utils/eventsummaryUtils/penaltyvalues.dart';

class EventSummaryScreen extends StatefulWidget {
  final String userKey;
  const EventSummaryScreen({super.key, required this.userKey});

  @override
  State<EventSummaryScreen> createState() => _EventSummaryScreenState();
}

class _EventSummaryScreenState extends State<EventSummaryScreen> {
  int totalEvent = 0;

  //color theme
  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getEvents();
    Provider.of<EventAttendanceProvider>(context, listen: false)
        .getEventAttendance();

    Provider.of<UsersProvider>(context, listen: false).getUser(widget.userKey);
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    Provider.of<PenaltyValuesProvider>(context, listen: false)
        .getPenaltyValues();
    super.initState();
  }

  final appBar = AppBar();

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),

          // Adjust padding to make it more compact
          content: SizedBox(
            width: 150,
            child: Row(
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(
                    width: 16), // Reduce spacing between indicator and text
                Text(
                  "Saving offline data ...",
                  style: TextStyle(fontSize: 16), // Adjust font size if needed
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    final userData = userProvider.userData;
    //user isAdmin
    final isAdmin = userData.isAdmin;

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        //events
        List<EventType> allEvents = provider.eventList;

        //sort by date
        allEvents.sort((a, b) => b.eventDate.compareTo(a.eventDate));

        //filter event ended
        final sortedEventEnded =
            allEvents.where((event) => event.eventEnded == true).toList();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Events Summary',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          isAdmin
                              ? GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PenaltyValuesScreen())),
                                  child: Icon(
                                    Icons.edit_note,
                                    size: 30,
                                  ),
                                )
                              : SizedBox.shrink(),
                          Consumer<EventAttendanceProvider>(
                              builder: (context, provider, child) {
                            //event attendance list
                            List<EventAttendance> eventAttendanceList =
                                provider.eventAttendanceList;

                            //filter unsave or data save offline
                            eventAttendanceList.where(
                                (element) => element.isDataSaveOffline == true);

                            return isAdmin
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: GestureDetector(
                                      onTap: eventAttendanceList.isEmpty
                                          ? () {
                                              print('tapped');
                                            }
                                          : () async {
                                              print('saving');
                                              showProgressDialog(context);
                                              try {
                                                for (var element
                                                    in eventAttendanceList) {
                                                  await Provider.of<
                                                              UsersProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateUserOfflineSaveData(
                                                          element.studentId);
                                                }
                                              } catch (e) {
                                                // Handle any exceptions here
                                                print('Error occurred: $e');
                                              } finally {
                                                // Close progress dialog here if needed
                                                Navigator.pop(context);
                                              }
                                            },
                                      child: Icon(
                                        Icons.save_alt_outlined,
                                        color: eventAttendanceList.isEmpty
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink();
                          })
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  'Events Ended',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade400,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: sortedEventEnded.length,
                        itemBuilder: (context, index) {
                          final item = sortedEventEnded.elementAt(index);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: GestureDetector(
                              onTap: isAdmin
                                  ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CoursesSummaryScreen(
                                                eventName: item.eventName,
                                                screenHeight: screenHeight,
                                                eventId: item.id,
                                                isAdmin: isAdmin,
                                                sortedEvent: sortedEventEnded,
                                              )))
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: purple,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: EventSummayBox(
                                  userAttendedEvent: userData.eventAttended,
                                  isAdmin: isAdmin,
                                  items: item,
                                  screeHeight: (screenHeight +
                                      statusbarHeight +
                                      appBarHeight),
                                  sortedEvent: sortedEventEnded,
                                ),
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
