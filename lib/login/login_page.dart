import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  bool codeSent = false;

  void _sendCode() async {
    final email = emailController.text.trim();
    final success = await AuthService.sendCode(email);

    if (success) {
      setState(() => codeSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code sent to $email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending code')),
      );
    }
  }

  void _verifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    final result = await AuthService.verifyCode(email, code);

    if (result != null) {
      final role = result['role'];
      String? year;

      if (role == 'student') {
        year = await AuthService.getStudentYearFromChoice(email);
      }

      final appState = p.Provider.of<AppState>(context, listen: false);
      await appState.setUser(role, email, year);

      print('✅ role: $role, email: $email, year: $year');

      if (!mounted) {
        print('⚠️ Widget not mounted');
        return;
      }

      print('🚀 Переход на /student/student');
      if (role == 'admin') {
        context.go('/admin/admin');
      } else {
        context.go('/student/student');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Make Your Choice',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0A0033))),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Enter your email'),
                    ),
                  ),
                  if (codeSent) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: codeController,
                        decoration: const InputDecoration(labelText: 'Enter the code'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 150,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: codeSent ? _verifyCode : _sendCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF625BFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text(
                        codeSent ? 'Verify' : 'Send Code',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset('assets/images/logog.jpg', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
