import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/login/app_state.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorcuurentbutton = Color(0xFF605BFF);
  static const Color textForNavBar = Colors.black54;
  static const Color grey = Colors.grey;
}

class NavBar extends StatelessWidget {
  final String currentRoute;
  final void Function(String route)? onNavigateTo;

  const NavBar({
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
                      '/admin/admin',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/admin',
                    ),
                    _buildNavItem(
                      context,
                      Icons.calendar_month,
                      'Setting deadlines',
                      '/admin/setting_deadlines',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/setting_deadlines',
                    ),
                    _buildNavItem(
                      context,
                      Icons.book_online_outlined,
                      'Electives',
                      '/admin/electives',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/electives',
                    ),
                    _buildNavItem(
                      context,
                      Icons.book_online_sharp,
                      'Draft',
                      '/admin/draft',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/draft',
                    ),
                    _buildNavItem(
                      context,
                      Icons.bookmark_add_sharp,
                      'Setting programs',
                      '/admin/setting_programs',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/setting_programs',
                    ),
                    _buildNavItem(
                      context,
                      Icons.list_alt,
                      'Results',
                      '/admin/results',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/results',
                    ),
                    _buildNavItem(
                      context,
                      Icons.settings,
                      'Help',
                      '/admin/help',
                      fontSize: baseFontSize,
                      selected: currentRoute == '/admin/help',
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
                        'Admin Account',
                        style: TextStyle(fontSize: baseFontSize * 0.8),
                      ),
                      trailing: const Icon(Icons.logout, color: Colors.red),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AppState>().logout();
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
