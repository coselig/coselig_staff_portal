import 'package:coselig_staff_portal/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coselig_staff_portal/services/auth_service.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = context.read<AuthService>();
    final attendance = context.read<AttendanceService>();
    if (!_requested && authService.userId != null) {
      _requested = true;
      attendance.getTodayAttendance(authService.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final attendance = context.watch<AttendanceService>();
    final userId = authService.userId;
    String? checkInTime = attendance.todayAttendance?['check_in_time'];
    String? checkOutTime = attendance.todayAttendance?['check_out_time'];
    String formatTime(String? dt) {
      if (dt == null || dt.isEmpty) return '--';
      final parts = dt.split(' ');
      return parts.length == 2 ? parts[1] : dt;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('員工系統'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '登出',
            onPressed: () async {
              await authService.logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('光悅員工系統', style: TextStyle(fontSize: 20))),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('登出'),
              onTap: () async {
                await authService.logout();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '歡迎，${authService.name ?? '員工'}！',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Text('今日上班時間：${formatTime(checkInTime)}')),
              ElevatedButton(
                onPressed: () async {
                  if (userId != null) {
                    await attendance.checkIn(userId);
                  }
                },
                child: Text(attendance.hasCheckedIn ? '補上班打卡' : '上班打卡'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Text('今日下班時間：${formatTime(checkOutTime)}')),
              ElevatedButton(
                onPressed: () async {
                  if (userId != null) {
                    await attendance.checkOut(userId);
                  }
                },
                child: Text(attendance.hasCheckedOut ? '補下班打卡' : '下班打卡'),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (attendance.errorMessage != null)
            Text(
              attendance.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
