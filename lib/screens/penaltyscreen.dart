import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/eventIdProvider.dart';
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
    0: ['', '', ''],
    1: ['2 Pencils', '1 Notebook', '1 YellowPad'],
    2: ['2 Pencils', '2 Notebook', '1 YellowPad'],
    3: ['3 Pencils', '2 Notebook', '2 YellowPad'],
    4: ['4 Pencils', '3 Notebook', '2 YellowPad'],
    5: ['4 Pencils', '3 Notebook', '3 YellowPad']
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
                                    item.isPenaltyShown
                                        ? const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                                            child: Text(
                                              'Penalties',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    item.isPenaltyShown
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 6, 0, 0),
                                            child: Consumer<EventIdProvider>(
                                              builder:
                                                  (context, provider, child) {
                                                final eventLength =
                                                    provider.eventLength;
                                                final penaltyData =
                                                    penaltyFormula[
                                                        getUserEventMissed(
                                                            item.eventAttended,
                                                            eventLength)];

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      penaltyData[0],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      penaltyData[1],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    item.isPenaltyShown
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 6, 0, 0),
                                            child: Consumer<EventIdProvider>(
                                              builder:
                                                  (context, provider, child) {
                                                final eventLength =
                                                    provider.eventLength;
                                                final penaltyData =
                                                    penaltyFormula[
                                                        getUserEventMissed(
                                                            item.eventAttended,
                                                            eventLength)];
                                                return Text(
                                                  penaltyData[2],
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
