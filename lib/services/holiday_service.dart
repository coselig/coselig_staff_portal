import 'dart:convert';
import 'package:http/http.dart' as http;

class HolidayService {
  /// 取得台灣某年份的國定假日（行政院公開資料）
  Future<List<Holiday>> fetchTaiwanHolidays(int year) async {
    final url =
        'https://cdn.jsdelivr.net/gh/ruyut/TaiwanCalendar/data/$year.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Holiday> holidays = [];
      // 新版格式直接是 List，舊版是 {"days": List}
      final List<dynamic> daysList =
          data is List ? data : (data['days'] as List<dynamic>? ?? []);
      for (final item in daysList) {
        if (item['isHoliday'] == true) {
          holidays.add(Holiday(
            date: item['date'],
            name: item['name'],
          ));
        }
      }
      return holidays;
    } else {
      throw Exception('無法取得國定假日資料');
    }
  }
}

class Holiday {
  final String date; // yyyy-MM-dd
  final String name;
  Holiday({required this.date, required this.name});
}
