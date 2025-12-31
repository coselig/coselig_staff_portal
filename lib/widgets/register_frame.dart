import 'package:coselig_staff_portal/main.dart';
import 'package:coselig_staff_portal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterFrame extends StatefulWidget {
  const RegisterFrame({super.key});

  @override
  State<RegisterFrame> createState() => _RegisterFrameState();
}

class _RegisterFrameState extends State<RegisterFrame> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
      height: MediaQuery.of(context).size.height * 0.28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: '電子郵件'),
          ),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: '帳號名稱'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: '密碼'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final success = await authService.register(
                usernameController.text,
                emailController.text,
                passwordController.text,
              );
              if (success) {
                if (!mounted) return;
                navigatorKey.currentState!.pushReplacementNamed('/home');
              }
              setState(() {});
            },
            child: const Text('註冊'),
          ),
          // SizedBox(height: 8),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Text(
          //       authService.message,
          //       style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
