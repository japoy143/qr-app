import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class PenaltyScreen extends StatefulWidget {
  const PenaltyScreen({super.key});

  @override
  State<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  final color = ColorThemeProvider();
  final TextEditingController _studentNameController = TextEditingController();

  List<String> courses = ['BSIT', 'BSCS', 'BSIS', 'BSCPE', 'BSECE'];
  String? selectedCourse = 'BSIT';

  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    Provider.of<EventIdProvider>(context, listen: false).getEventIdLength();
    Provider.of<EventIdProvider>(context, listen: false).getEvents();
    _studentNameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    super.dispose();
  }

  Map<int, dynamic> penaltyFormula = {
    0: ['', '', '', ''],
    10: ['1 Ballpen', '1 Pencil', '', ''],
    20: ['2 Ballpen', '2 Pencil', '', ''],
    30: ['1 Ballpen', '1 Pencil', '1 Crayons 8 colors', ''],
    40: ['1 Pad Paper', '1 Crayons 8 colors', '', ''],
    50: [
      '1 Ballpen',
      '1 Pencil',
      '1 Crayons 8 colors',
      '1 Pad Paper',
    ],
    60: [
      '1 Pad Paper',
      '1 Crayons 8 colors',
      '1 Small Notebook',
      '',
    ],
    70: ['1 Crayons 8 colors', '1 Pad Paper', '1 Small Notebook', ''],
    80: ['1 Ballpen', '1 Pencil', '1 Pad Paper', '1 Big Notebook'],
    90: ['1 Big NoteBook', '2 Small Notebook', '', ''],
    100: [
      '1 Crayons 8 colors',
      '1 Pad Paper',
      '1 Small Notebook',
      '1 Big Notebook'
    ],
  };

  //user attended
  int getUserTotalAttended(String eventAttended) {
    List attend = eventAttended.split('|');

    int totalEventAttended = attend.length - 1;

    return totalEventAttended;
  }

  int getUserEventMissed(String eventAttended, int totalEvent) {
    List attend = eventAttended.split('|');

    int totalEventAttended = attend.length - 1;
    int eventMissed = totalEvent - totalEventAttended;

    return eventMissed;
  }

  int getEventTotalValue(List eventAttended, Map<dynamic, int> ids) {
    int total = 0;

    eventAttended.forEach((element) {
      if (element != "") {
        total += ids[element] ?? 0;
      }
    });

    return total;
  }

  List getEventAttendedList(String attended) {
    List attend = attended.split('|');
    attend.remove("");

    return attend;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Color purple = Color(color.hexColor(color.primaryColor));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Penalties',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Student Penalties',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade400,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Search Students',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      height: screenHeight,
                      hintext: 'enter student name',
                      controller: _studentNameController,
                      keyBoardType: TextInputType.text,
                      isReadOnly: false,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: DropDown(
                      initialValue: selectedCourse,
                      showUnderline: false,
                      items: courses,
                      onChanged: (val) {
                        setState(() {
                          selectedCourse = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: DropDown(
                      initialValue: selectedYear,
                      showUnderline: false,
                      items: year,
                      onChanged: (val) {
                        setState(() {
                          selectedYear = val as int?;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Consumer<UsersProvider>(
                  builder: (context, provider, child) {
                    final users = provider.userList;

                    // Filter users by selected course and exclude admins
                    final userAttendanceList = users
                        .where((student) =>
                            student.userCourse == selectedCourse &&
                            student.isAdmin != true)
                        .toList();

                    // Further filter by selected year
                    final sortedCoursesAndYear = userAttendanceList
                        .where((student) =>
                            student.userYear == selectedYear.toString())
                        .toList();

                    // Search by student name
                    final usersList = _studentNameController.text.isEmpty
                        ? sortedCoursesAndYear
                        : sortedCoursesAndYear
                            .where((student) => student.userName
                                .toLowerCase()
                                .contains(
                                    _studentNameController.text.toLowerCase()))
                            .toList();

                    // Display message if no students found
                    if (usersList.isEmpty) {
                      return const Center(
                        child: Text('Student Not Found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        final item = usersList.elementAt(index);

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                item.isPenaltyShown = !item.isPenaltyShown;
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(26),
                                decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.userName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '${item.userCourse}-${item.userYear}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    item.isPenaltyShown
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Event Attended: ${getUserTotalAttended(item.eventAttended).toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Consumer<EventIdProvider>(
                                                  builder: (context, provider,
                                                      child) {
                                                    final eventLength =
                                                        provider.eventLength;

                                                    return Text(
                                                      'Total Events: $eventLength',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    item.isPenaltyShown
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Consumer<EventIdProvider>(
                                              builder:
                                                  (context, provider, child) {
                                                final eventLength =
                                                    provider.eventLength;
                                                return Text(
                                                  'Event Missed: ${getUserEventMissed(item.eventAttended, eventLength).toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    Consumer<EventProvider>(
                                        builder: (context, provider, child) {
                                      List<EventType> events =
                                          provider.eventList;

                                      List<EventType> eventEnded = events
                                          .where((element) =>
                                              element.eventEnded == true)
                                          .toList();

                                      //attended event
                                      List attendedEvent = getEventAttendedList(
                                          item.eventAttended);

                                      //all not attended
                                      List penaltyEvent = [];

                                      //filter not equal event attended
                                      eventEnded.forEach((ids) {
                                        bool isAttended = attendedEvent.any(
                                            (element) =>
                                                int.parse(element) == ids.id);

                                        if (!isAttended) {
                                          penaltyEvent.add(ids.id);
                                        }
                                      });

                                      final eventIds = Map.fromEntries(
                                        events.map(
                                          (e) => MapEntry(e.id, e.eventPenalty),
                                        ),
                                      );

                                      int totalValue = getEventTotalValue(
                                          penaltyEvent, eventIds);

                                      final penalty = totalValue >= 100
                                          ? penaltyFormula[100]
                                          : penaltyFormula[totalValue];

                                      return item.isPenaltyShown
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 0),
                                                  child: Text(
                                                    'Total Event Penalty   ₱${getEventTotalValue(penaltyEvent, eventIds).toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                item.isPenaltyShown
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 4, 0, 4),
                                                        child: Text(
                                                          'Converted Penalty',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                item.isPenaltyShown
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            penalty[0],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            penalty[1],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                                item.isPenaltyShown
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            penalty[2],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            penalty[3],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            )
                                          : const SizedBox.shrink();
                                    }),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
