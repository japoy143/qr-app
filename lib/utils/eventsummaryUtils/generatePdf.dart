import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path/path.dart' as path;

class SaveAndDownloadPdf {
  static createPdf({
    required final String eventName,
    required String eventDescription,
    required String eventTime,
    required int totalAttended,
    required List<List<dynamic>> data,
  }) async {
    final doc = pw.Document();

    List headers = [
      'Courses',
      '1st Year',
      '2nd Year',
      '3rd Year',
      '4th Year',
      'Total Students Attended'
    ];
    //img
    final img = (await rootBundle.load('assets/imgs/lsg_pdf_logo.jpg'))
        .buffer
        .asUint8List();

    doc.addPage(
      pw.Page(
          build: (context) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('LSG',
                                      style: pw.TextStyle(
                                          fontSize: 24,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('6C63FF'))),
                                  pw.Text('Event Report',
                                      style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Text(eventName,
                                      style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Text(eventDescription,
                                      style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Text(
                                      'Total Student Attended: $totalAttended'),
                                ]),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Image(pw.MemoryImage(img),
                                      height: 60, width: 60),
                                  pw.Padding(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: pw.Text('Date:$eventTime')),
                                ])
                          ]),
                    ),
                    pw.TableHelper.fromTextArray(
                        data: data,
                        headers: headers,
                        tableWidth: pw.TableWidth.max,
                        headerHeight: 80,
                        cellHeight: 60,
                        cellAlignment: pw.Alignment.center,
                        headerAlignment: pw.Alignment.center,
                        border: pw.TableBorder.all(width: 4),
                        headerStyle: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        cellStyle: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold))
                  ])),
    );

    final dir = await getTemporaryDirectory();
    final filename = '$eventName.pdf';
    final savePath = path.join(dir.path, filename);
    final file = File(savePath);
    await file.writeAsBytes(await doc.save());
    OpenFilex.open(file.path);
  }
}
