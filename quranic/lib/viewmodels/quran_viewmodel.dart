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
        String arabic = json['arabic1'] ?? "No Arabic text is available";
        String english = json['english'] ?? "No English translation is available";
        String bangla = json['bangla'] ?? "No Bengali translation is available";
        String surahNameArabic = json['surahNameArabic'] ?? "No Arabic Surah name is available";
        String surahNameTranslation = json['surahNameTranslation'] ?? "No Surah name translation is available";
        String revelationPlace = json['revelationPlace'] ?? "No revelation place is available";

        return {
          'arabic': arabic,
          'english': english,
          'bangla': bangla,
          'surahNameArabic': surahNameArabic,
          'surahNameTranslation': surahNameTranslation,
          'revelationPlace': revelationPlace,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
