import 'package:flutter/material.dart';
import 'package:qr_app/screens/forms/formUtils/customtextField.dart';
import 'package:qr_app/screens/forms/formUtils/dropDownItem.dart';


class CreateAccountScreen extends StatefulWidget {
  final Color textColor;
  const CreateAccountScreen({super.key, required this.textColor});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  List<String> Courses = ['BSIT', 'BSCS', "BSIS", "BSCPE", "BSECE"];
  String? selectedCourse = 'BSIT';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LSG',
          style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 24.0),
        ),
        Text(
          'Sign Up',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 40.0,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'Please enter your details',
          style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 45.0, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              CustomTextField(
                  hintext: 'enter name', controller: _nameController),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 5, 40.0, 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'School Id',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                    ),
                    CustomTextField(
                        hintext: 'enter school id',
                        controller: _nameController),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: widget.textColor, // Set the border color to purple
              //         width: 2.0, // Optional: Set the border width
              //         style:
              //             BorderStyle.solid, // Optional: Set the border style
              //       ),
              //     ),
              //     padding: EdgeInsets.all(10.0),
              //     child: ,
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'School Id',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                    ),
                    CustomTextField(
                        hintext: 'enter school id',
                        controller: _nameController),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
