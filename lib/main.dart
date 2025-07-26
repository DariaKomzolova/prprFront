import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:loginsso/login/app_state.dart';
import 'package:loginsso/login/router.dart';
import 'package:loginsso/admin_panel/providers/elective_provider.dart'; 
import 'package:loginsso/student_panel/providers/elective_provider_student.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rntkskjugmggmkzvslco.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJudGtza2p1Z21nZ21renZzbGNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE3ODgwNTksImV4cCI6MjA2NzM2NDA1OX0.Mh2L0PZ9O13vBwQJP6tlIq18U7H7Dv9P5nu4MamnhE0',
  );

  final appState = AppState();
  await appState.loadFromStorage();

  runApp(
    p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider(create: (_) => appState),
        p.ChangeNotifierProvider(create: (_) => ElectivesProviderAdmin()),
        p.ChangeNotifierProvider(create: (_) => ElectivesProviderStudent(appState)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = p.Provider.of<AppState>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(appState),
    );
  }
}
