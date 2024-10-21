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

    List headers = [
      'Event Name',
      'Event Date',
      'Total',
    ];

    final imgCite = (await rootBundle.load('assets/imgs/cite_logo.png'))
        .buffer
        .asUint8List();

    final imgNDMC =
        (await rootBundle.load('assets/imgs/nd_logo.png')).buffer.asUint8List();

    int getAttendanceList(String attendance, int id, int eventValue) {
      List splitAttendance = attendance.split("|");
      splitAttendance.remove("");
      bool isIdexist =
          splitAttendance.any((element) => int.parse(element) == id);

      return isIdexist ? 0 : eventValue;
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
      pageFormat: PdfPageFormat.legal,
      margin: const pw.EdgeInsets.all(10),
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(imgCite), height: 60, width: 60),
              pw.Column(
                children: [
                  pw.Text('NOTRE DAME OF MIDSAYAP COLLEGE',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('97e08a'))),
                  pw.Text('College of Information Technology and Engineering',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('492971'))),
                ],
              ),
              pw.Image(pw.MemoryImage(imgNDMC), height: 60, width: 60),
            ],
          ),
        ),
        pw.Text('Attendance Sheet for A.Y 2024-2025',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            )),
        pw.SizedBox(height: 10),

        // Iterate through users and create tables with auto pagination
        ...users.map((user) {
          final List<List<dynamic>> data = events.map((e) {
            return [
              e.eventName.toString(),
              DateFormat('MMMM dd, yyyy').format(e.eventDate),
              getAttendanceList(user.eventAttended, e.id, e.eventPenalty)
            ];
          }).toList();

          const int rowsPerPage = 8; // Set the number of rows per page
          List<List<List<dynamic>>> chunks = [];
          for (var i = 0; i < data.length; i += rowsPerPage) {
            chunks.add(data.sublist(i,
                i + rowsPerPage > data.length ? data.length : i + rowsPerPage));
          }

          List attendedEvent = getEventAttendedList(user.eventAttended);
          List penaltyEvent = [];
          events.forEach((ids) {
            bool isAttended =
                attendedEvent.any((element) => int.parse(element) == ids.id);
            if (!isAttended) {
              penaltyEvent.add(ids.id);
            }
          });

          final eventIds = Map.fromEntries(
            events.map((e) => MapEntry(e.id, e.eventPenalty)),
          );

          int totalValue = getEventTotalValue(penaltyEvent, eventIds);

          PenaltyValues maxPenalty = penaltyValues
              .reduce((a, b) => a.penaltyprice > b.penaltyprice ? a : b);

          PenaltyValues values = totalValue >= maxPenalty.penaltyprice
              ? maxPenalty
              : penaltyValues
                  .firstWhere((element) => element.penaltyprice >= totalValue);

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 14),
              pw.Text('ID No: ${user.schoolId}'),
              pw.Text(
                  'Name: ${user.lastName}, ${user.userName} ${user.middleInitial}.'),
              pw.Text('Course: ${user.userCourse}-${user.userYear}'),
              pw.SizedBox(height: 20),

              // Loop through the data chunks and render each chunk in a new table
              ...chunks.map((chunk) {
                return pw.Column(
                  children: [
                    pw.Table.fromTextArray(
                      headers: headers,
                      data: chunk,
                      cellHeight: 40,
                      cellAlignment: pw.Alignment.center,
                      border: pw.TableBorder.all(
                        width: 2,
                        style: pw.BorderStyle.dashed,
                        color: PdfColors.grey,
                      ),
                      headerStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                      cellStyle: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              pw.Text('Overall Total Fines: ${totalValue}'),
              pw.SizedBox(height: 10),
              pw.Text('Penalty: ${values.penaltyvalue}'),
              pw.Divider(),
            ],
          );
        }).toList(),
      ],
    ));

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
