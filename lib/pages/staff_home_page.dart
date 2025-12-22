import 'package:coselig_staff_portal/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coselig_staff_portal/services/auth_service.dart';

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final attendance = context.watch<AttendanceService>();
    return Scaffold(
      appBar: AppBar(title: const Text('員工系統')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '歡迎，${authService.name ?? '員工'}！',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: attendance.hasCheckedIn
                ? null
                : () async {
                    await attendance.checkIn("1");
                  },
            child: const Text('上班打卡'),
          ),
          ElevatedButton(
            onPressed: attendance.hasCheckedOut
                ? null
                : () async {
                    await attendance.checkOut("1");
                  },
            child: const Text('下班打卡'),
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
