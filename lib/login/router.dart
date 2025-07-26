import 'package:go_router/go_router.dart';
import 'package:loginsso/login/login_page.dart';
import 'package:loginsso/login/app_state.dart';

// Admin pages
import 'package:loginsso/admin_panel/main_page.dart' as admin;
import 'package:loginsso/admin_panel/programs_page.dart';
import 'package:loginsso/admin_panel/deadline_pages.dart';
import 'package:loginsso/admin_panel/draft_page.dart';
import 'package:loginsso/admin_panel/result_page.dart';
import 'package:loginsso/admin_panel/help_page.dart';
import 'package:loginsso/admin_panel/electives_page.dart';

// Instructor pages
import 'package:loginsso/instructor_panel/main_page.dart' as instructor;
import 'package:loginsso/instructor_panel/electives_page.dart' as instructor;
import 'package:loginsso/instructor_panel/help_page.dart' as instructor;

// Student pages
import 'package:loginsso/student_panel/main_page.dart' as student;
import 'package:loginsso/student_panel/humanitarian_page.dart';
import 'package:loginsso/student_panel/technical_page.dart';
import 'package:loginsso/student_panel/help_page.dart' as student;

GoRouter createRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: appState,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      // Admin routes
      GoRoute(path: '/admin/admin', builder: (context, state) => const admin.AdminHomePage()),
      GoRoute(path: '/admin/setting_programs', builder: (context, state) => const ProgramsPage()),
      GoRoute(path: '/admin/setting_deadlines', builder: (context, state) => const DeadlinesPage()),
      GoRoute(path: '/admin/draft', builder: (context, state) => const DraftPage()),
      GoRoute(path: '/admin/results', builder: (context, state) => const ResultsPage()),
      GoRoute(path: '/admin/help', builder: (context, state) => const HelpPageAdmin()),
      GoRoute(path: '/admin/electives', builder: (context, state) => const ElectivesPageAdmin()),

      // Instructor routes
      GoRoute(path: '/instructor/instructor', builder: (context, state) => const instructor.InstructorHomePage()),
      GoRoute(path: '/instructor/electives', builder: (context, state) => const instructor.ElectivesPageInstructor()),
      GoRoute(path: '/instructor/help', builder: (context, state) => const instructor.HelpPageInstructor()),

      // Student routes
      GoRoute(
  path: '/student/student',
  builder: (context, state) => const student.StudentHomePage(),
),


      GoRoute(path: '/student/humanitarian', builder: (context, state) => const HumElectivesPage()),
      GoRoute(path: '/student/technical', builder: (context, state) => const TechElectivesPage()),
      GoRoute(path: '/student/help', builder: (context, state) => const student.HelpPageStudent()),
    ],
    redirect: (context, state) {
      final role = appState.role;
      final path = state.fullPath ?? '';

      if (role == null) {
  return path == '/login' ? null : '/login';
}

if (path == '/login') {
  switch (role) {
    case 'student':
      return '/student/student';
    case 'admin':
      return '/admin/admin';
    case 'instructor':
      return '/instructor/instructor';
  }
}


      if (role == 'student' && (path.startsWith('/admin') || path.startsWith('/instructor'))) {
        return '/student/student';
      }

      if (role == 'admin' && (path.startsWith('/student') || path.startsWith('/instructor'))) {
        return '/admin/admin';
      }

      if (role == 'instructor' && (path.startsWith('/admin') || path.startsWith('/student'))) {
        return '/instructor/instructor';
      }

      return null;
    },
  );
}
