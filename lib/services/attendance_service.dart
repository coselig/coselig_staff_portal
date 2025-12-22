import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceService extends ChangeNotifier {
  static const String baseUrl =
      'https://employeeservice.coseligtest.workers.dev';

  Map<String, dynamic>? todayAttendance;
  String? errorMessage;

  /// 上班打卡
  Future<bool> checkIn(String userId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/attendance/check-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (res.statusCode == 200) {
      await getTodayAttendance(userId);
      return true;
    } else {
      errorMessage = jsonDecode(res.body)['error'];
      notifyListeners();
      return false;
    }
  }

  /// 下班打卡
  Future<bool> checkOut(String userId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/attendance/check-out'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (res.statusCode == 200) {
      await getTodayAttendance(userId);
      return true;
    } else {
      errorMessage = jsonDecode(res.body)['error'];
      notifyListeners();
      return false;
    }
  }

  /// 取得今天打卡狀態（⚠️ GET）
  Future<void> getTodayAttendance(String userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/attendance/today?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      todayAttendance = jsonDecode(res.body);
      errorMessage = null;
      notifyListeners();
    } else {
      throw Exception('Failed to load attendance data');
    }
  }

  bool get hasCheckedIn =>
      todayAttendance?['check_in_time'] != null;

  bool get hasCheckedOut =>
      todayAttendance?['check_out_time'] != null;
}
