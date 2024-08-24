// import 'dart:io';

// import 'package:pdf/widgets.dart';
// import 'package:qr_app/utils/eventsummaryUtils/generatePdf.dart';

// class SimplePdfApi {
//   static Future<File> generateSimpleTextPdf(String text, String text2) async {
//     final pdf = Document();

//     pdf.addPage(Page(
//         build: (_) => Center(
//                 child: Column(children: [
//               Text(text, style: TextStyle(fontSize: 48)),
//               Text(text2, style: TextStyle(fontSize: 48))
//             ]))));

//     return SaveAndOpenPdf.savePdf(name: 'simple_pdf', pdf: pdf);
//   }
// }
