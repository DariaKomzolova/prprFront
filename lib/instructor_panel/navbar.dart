import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorcuurentbutton = Color(0xFF605BFF);
  static const Color textForNavBar = Colors.black54;
  static const Color grey = Colors.grey;
}

class InstructorNavBar extends StatelessWidget {
  final String currentRoute;
  final void Function(String route)? onNavigateTo;

  const InstructorNavBar({
    super.key,
    required this.currentRoute,
    this.onNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
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
                      '/instructor/instructor',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/instructor',
                    ),
                    _buildNavItem(
                      context,
                      Icons.book_online_outlined,
                      'Electives',
                      '/instructor/electives',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/instructor/electives',
                    ),
                    _buildNavItem(
                      context,
                      Icons.settings,
                      'Help',
                      '/instructor/help',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/instructor/help',
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
                        'Ivan Ivanov',
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                      subtitle: Text(
                        'Instructor Account',
                        style: TextStyle(fontSize: baseFontSize * 0.8),
                      ),
                      trailing: const Icon(Icons.logout, color: Colors.red),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
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
              color: AppColors.colorcuurentbutton.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? AppColors.colorcuurentbutton : AppColors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: selected ? AppColors.colorcuurentbutton : AppColors.textForNavBar,
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
