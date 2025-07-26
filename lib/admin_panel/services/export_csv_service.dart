import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

Future<void> downloadCSV() async {
  final url = Uri.parse('https://prprback.onrender.com/download-results');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final blob = html.Blob([response.bodyBytes], 'text/csv');
    final urlBlob = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: urlBlob)
      ..setAttribute('download', 'results.csv')
      ..click();

    html.Url.revokeObjectUrl(urlBlob);
  } else {
    throw Exception('Failed to download CSV');
  }
}
