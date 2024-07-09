import 'package:charset_converter/charset_converter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart' as xml;

class GoogleSearch {
  static Future<List<String>> getSuggestions(String query) async {
    final response = await http.get(
      Uri.parse(
          'http://toolbarqueries.google.com/complete/search?q=$query&output=toolbar&hl=tr'),
    );
    if (response.statusCode == 200) {
      String? responseEncoding = RegExp(r'charset=([^;]+)')
          .firstMatch(response.headers['content-type'] ?? '')
          ?.group(1);

      String responseBody = await CharsetConverter.decode(
        responseEncoding ?? 'utf-8',
        response.bodyBytes,
      );

      var document = xml.XmlDocument.parse(responseBody);
      return document
          .findAllElements('suggestion')
          .map((suggestion) => suggestion.getAttribute('data') ?? '')
          .toList();
    }
    return [];
  }

  static Future<bool> openSearch(String query) async {
    return await launchUrl(
        Uri.https(
          'www.google.com',
          '/search',
          {'q': query},
        ),
        mode: LaunchMode.externalApplication);
  }
}
