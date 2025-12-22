import 'package:coselig_staff_portal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginFrame extends StatefulWidget {
  const LoginFrame({super.key});

  @override
  State<LoginFrame> createState() => _LoginFrameState();
}

class _LoginFrameState extends State<LoginFrame> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(28, 211, 80, 40),
      ),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: accountController,
            decoration: const InputDecoration(labelText: '電子郵件/帳號'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: '密碼'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final success = await authService.login(
                accountController.text,
                passwordController.text,
              );
              if (success) {
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              }
              setState(() {});
            },
            child: const Text('登入'),
          ),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                authService.message,
                style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
