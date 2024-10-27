// viewmodels/quran_viewmodel.dart


import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranViewModel {
  Future<Map<String, String>?> fetchAyah(int surahNo, int ayahNo) async {
    final String baseUrl =
        'https://quranapi.pages.dev/api/$surahNo/$ayahNo.json';

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        String arabic = json['arabic1'] ?? "No Arabic text available";
        String english = json['english'] ?? "No English translation available";
        String bangla = json['bangla'] ?? "No Bengali translation available";

        return {
          'arabic': arabic,
          'english': english,
          'bangla': bangla,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
