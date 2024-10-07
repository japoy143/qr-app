import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path/path.dart' as path;
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/penaltyvalues.dart';
import 'package:qr_app/models/users.dart';

class SaveAndDownloadMultiplePdf {
  static createPdf({
    required final List<UsersType> users,
    required final List<EventType> events,
    required final List<PenaltyValues> penaltyValues,
  }) async {
    final doc = pw.Document();

    // //penalties
    // Map<int, dynamic> penaltyFormula = {
    //   0: '',
    //   10: '1 ballpen / pencil',
    //   20: '2 ballpen / pencil',
    //   30: '1 ballpen / pencil, 1 Crayons 8 colors',
    //   40: '1 pad paper, 1 crayons 8 colors',
    //   50: '1 ballpen / pencil, 1 crayons 8 colors, 1 pad paper',
    //   60: '1 pad paper, 1 crayons 8 colors, 1 small notebook',
    //   70: '1 crayons 8 colors, 1 pad paper, 1 small notebook',
    //   80: '1 ballpen / pencil, 1 pad paper, 1 big notebook',
    //   90: '1 big notebook, 2 small notebook',
    //   100: '1 crayons 8 colors, 1 pad paper, 1 small notebook, 1 big notebook',
    // };

    List headers = [
      'Event Name',
      'Event Date',
      'Total',
    ];
    //img
    final imgCite = (await rootBundle.load('assets/imgs/cite_logo.png'))
        .buffer
        .asUint8List();

    final imgNDMC =
        (await rootBundle.load('assets/imgs/nd_logo.png')).buffer.asUint8List();

    //get attendance
    int getAttendanceList(String attendance, int id, int eventValue) {
      List splitAttendance = attendance.split("|");
      splitAttendance.remove("");

      bool isIdexist =
          splitAttendance.any((element) => int.parse(element) == id);

      if (!isIdexist) {
        return eventValue;
      }

      return 0;
    }

    List getEventAttendedList(String attended) {
      List attend = attended.split('|');
      attend.remove("");

      return attend;
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

    doc.addPage(pw.MultiPage(
        maxPages: users.isEmpty ? 1 : users.length * 2,
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              //header
              pw.Container(
                padding: const pw.EdgeInsets.only(
                    bottom: 3 * PdfPageFormat.mm, right: 10.0, left: 10.0),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Image(pw.MemoryImage(imgCite), height: 60, width: 60),
                      pw.Column(children: [
                        pw.Text('NOTRE DAME OF MIDSAYAP COLLEGE',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('97e08a'))),
                        pw.Text(
                            'College of Information Technology and Engineering',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('492971')))
                      ]),
                      pw.Image(pw.MemoryImage(imgNDMC), height: 60, width: 60),
                    ]),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.Text('Attendance Sheet for A.Y 2024-2025',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              //contents

              pw.ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users.elementAt(index);

                  var data = events.map((e) {
                    return [
                      e.eventName.toString(),
                      DateFormat('MMMM dd, yyyy').format(e.eventDate),
                      getAttendanceList(
                          user.eventAttended, e.id, e.eventPenalty)
                    ];
                  }).toList();

                  //attended event
                  List attendedEvent = getEventAttendedList(user.eventAttended);

                  //all not attended
                  List penaltyEvent = [];

                  //filter not equal event attended
                  events.forEach((ids) {
                    bool isAttended = attendedEvent
                        .any((element) => int.parse(element) == ids.id);

                    if (!isAttended) {
                      penaltyEvent.add(ids.id);
                    }
                  });

                  final eventIds = Map.fromEntries(
                    events.map(
                      (e) => MapEntry(e.id, e.eventPenalty),
                    ),
                  );

                  int totalValue = getEventTotalValue(penaltyEvent, eventIds);

                  PenaltyValues maxPenalty = penaltyValues.reduce(
                      (a, b) => a.penaltyprice > b.penaltyprice ? a : b);

                  PenaltyValues values = totalValue >= maxPenalty.penaltyprice
                      ? maxPenalty
                      : penaltyValues.firstWhere(
                          (element) => element.penaltyprice >= totalValue);

                  return pw.Container(
                      child: pw.Column(children: [
                    pw.SizedBox(height: 14),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('ID No: ${user.schoolId}'),
                            pw.Text(
                                'Name: ${user.lastName}, ${user.userName} .${user.middleInitial} '),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(''),
                            pw.Text(
                                'Course: ${user.userCourse}-${user.userYear}')
                          ],
                        )
                      ],
                    ),
                    pw.TableHelper.fromTextArray(
                      data: data,
                      headers: headers,
                      tableWidth: pw.TableWidth.max,
                      headerHeight: 40,
                      cellHeight: 40,
                      cellAlignment: pw.Alignment.center,
                      headerAlignment: pw.Alignment.center,
                      border: pw.TableBorder.all(
                          width: 2,
                          style: pw.BorderStyle.dashed,
                          color: PdfColors.grey),
                      headerStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                      cellStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 14),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text('Overall Total Fines: ${totalValue}')
                        ]),
                    pw.TableHelper.fromTextArray(
                      data: [],
                      headers: [values.penaltyvalue],
                      tableWidth: pw.TableWidth.max,
                      headerHeight: 40,
                      cellHeight: 40,
                      cellAlignment: pw.Alignment.center,
                      headerAlignment: pw.Alignment.center,
                      border: pw.TableBorder.all(
                          width: 2,
                          style: pw.BorderStyle.dashed,
                          color: PdfColors.grey),
                      headerStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                      cellStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ]));
                },
              )
            ]));

    //for filename date of school year
    final schoolYear =
        DateFormat('MMMM,yyyy').format(DateTime.now()).toString();

    final dir = await getTemporaryDirectory();
    final filename = 'Attendance Sheet ${schoolYear}.pdf';
    final savePath = path.join(dir.path, filename);
    final file = File(savePath);
    await file.writeAsBytes(await doc.save());
    OpenFilex.open(file.path);
  }
}
