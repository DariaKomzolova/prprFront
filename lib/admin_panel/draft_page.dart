import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/admin_panel/navbar.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorbigtext = Color(0xFF030229);
}


class DraftPage extends StatelessWidget {
  const DraftPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Draft',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorbigtext,
          ),
        ),
      ),
      drawer: NavBar(currentRoute: currentRoute),
    );
  }
}


