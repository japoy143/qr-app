import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class PenaltyScreen extends StatefulWidget {
  const PenaltyScreen({
    super.key,
  });

  @override
  State<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  final color = ColorThemeProvider();
  final TextEditingController _studentNameController = TextEditingController();
  bool _showNotFoundMessage = false;

  List<String> courses = ['BSIT', 'BSCS', 'BSIS', 'BSCPE', 'BSECE'];
  String? selectedCourse = 'BSIT';

  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    _studentNameController.addListener(_updateNotFoundMessage);
    super.initState();
  }

  @override
  void dispose() {
    _studentNameController.removeListener(_updateNotFoundMessage);
    _studentNameController.dispose();
    super.dispose();
  }

  void _updateNotFoundMessage() {
    final filteredList = _filteredList();
    setState(() {
      _showNotFoundMessage =
          _studentNameController.text.isNotEmpty && filteredList.isEmpty;
    });
  }

  List<UsersType> _filteredList() {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    final users = provider.userList;

    final userAttendanceList =
        users.where((student) => student.userCourse == selectedCourse).toList();

    final sortedCoursesAndYear = userAttendanceList
        .where((student) => student.userYear == selectedYear.toString())
        .toList();

    return _studentNameController.text.isEmpty
        ? sortedCoursesAndYear
        : sortedCoursesAndYear
            .where((student) => student.userName
                .toLowerCase()
                .contains(_studentNameController.text.toLowerCase()))
            .toList();
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
                      isReadOnly: false),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade900)),
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
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade900)),
                  child: DropDown(
                    initialValue: selectedYear,
                    showUnderline: false,
                    items: year,
                    onChanged: (val) {
                      setState(() {
                        selectedYear = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
                child: _showNotFoundMessage
                    ? const Center(child: Text("Student not found"))
                    : ListView.builder(
                        itemCount: _filteredList().length,
                        itemBuilder: (context, index) {
                          final item = _filteredList().elementAt(index);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(item.userName),
                              ),
                            ),
                          );
                        }))
          ],
        )),
      ),
    );
  }
}
