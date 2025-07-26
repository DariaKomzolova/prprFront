import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/presentation/colors/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:loginsso/login/app_state.dart';


class StudentNavBar extends StatelessWidget {
  final String currentRoute;
  final void Function(String route)? onNavigateTo;

  const StudentNavBar({
    super.key,
    required this.currentRoute,
    this.onNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AppState>().email ?? 'Unknown';
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * 0.4;

    return Drawer(
      width: drawerWidth.clamp(200.0, 400.0),
      backgroundColor: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double baseFontSize = (constraints.maxWidth / 22).clamp(12.0, 18.0);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                child: Image.asset(
                  'assets/images/innopolis.png',
                  height: 60,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildNavItem(
                      context,
                      Icons.grid_view_rounded,
                      'Main',
                      '/student/student',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/student/student',
                    ),
                    _buildNavItem(
                      context,
                      Icons.table_chart_rounded,
                      'Technical electives',
                      '/student/technical',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/student/technical',
                    ),
                    _buildNavItem(
                      context,
                      Icons.book,
                      'Humanitarian electives',
                      '/student/humanitarian',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/student/humanitarian',
                    ),
                    _buildNavItem(
                      context,
                      Icons.settings,
                      'Help',
                      '/student/help',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/student/help',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logog.jpg',
                      height: 80,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        email,
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                      subtitle: Text(
                        'Student Account',
                        style: TextStyle(fontSize: baseFontSize * 0.8),
                      ),
                      trailing: const Icon(Icons.logout, color: Colors.red),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AppState>().logout();
                      }
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String routeName, {
    required double fontSize,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: selected
          ? BoxDecoration(
              color: AppColors.colorcuurentbuttonNavBar.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected
              ? AppColors.colorcuurentbuttonNavBar
              : AppColors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: selected
                ? AppColors.colorcuurentbuttonNavBar
                : AppColors.textForNavBar,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (onNavigateTo != null) {
            onNavigateTo!(routeName);
          } else {
            context.go(routeName); 
          }
        },
      ),
    );
  }
}
