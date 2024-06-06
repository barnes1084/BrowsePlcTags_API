import 'dart:convert';
import 'dart:html' as html;

Future<void> saveCsvToFile(String csvData) async {
  // Prepare the data
  final bytes = utf8.encode(csvData);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "data.csv")
    ..click();
  html.Url.revokeObjectUrl(url);
}
