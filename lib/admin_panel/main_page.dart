import 'package:flutter/material.dart';
import 'package:loginsso/admin_panel/navbar.dart';
import 'package:go_router/go_router.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorbigtext = Color(0xFF030229);
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        title: const Text(
          'Main',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorbigtext,
          ),
        ),
      ),
      drawer: NavBar(currentRoute: currentRoute),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Analytics",
                            selectionColor: Color(0xFF030229),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _deadlineCard("The beginning of electives selection",
                            "Date", "Time"),
                        const SizedBox(height: 12),
                        _deadlineCard("The end of electives selection",
                            "Date", "Time"),
                        const SizedBox(height: 12),
                        _countdownCard("Left"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("The popularity of technical electives",
                            selectionColor: Color(0xFF030229),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("The popularity of humanitarian electives",
                            selectionColor: Color(0xFF030229),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget _deadlineCard(String title, String date, String time) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(date),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.access_time, size: 18),
                Text(time),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget _countdownCard(String countdownText) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 12),
            Expanded(child: Text(countdownText)),
          ],
        ),
      ),
    );
  }
}
