import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:coselig_staff_portal/pages/auth_page.dart';
import 'package:coselig_staff_portal/pages/staff_home_page.dart';
import 'package:coselig_staff_portal/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = context.watch<AuthService>();
    if (!_navigated && !authService.isLoading) {
      _navigated = true;
      Future.microtask(() {
        if (!mounted) return;
        if (authService.isLoggedIn) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ctc_icon.png',
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            SizedBox(height: 24),
            Text(
              '光悅員工系統',
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(24),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '載入中...',
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
