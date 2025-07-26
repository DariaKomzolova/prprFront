import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/admin_panel/navbar.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color textOfMakeYourChoiceLoginPage = Color(0xFF030229);
  static const Color purpleButtonColor = Color(0xFF605BFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorHelpPage = Color(0xFF030229);
  static const Color grey = Color(0xFFB0B0B0);
  static const Color black = Color(0xFF000000);
  static const Color textBlack = Color(0xFF030229);
  static const Color colorpbuttonNavBar = Color(0xFF030229);
  static const Color colorcuurentbuttonNavBar = Color(0xFF605BFF);
  static const Color notcurrentbuttonNavBar = Colors.grey;
  static const Color textForNavBar = Colors.black54;
  static const Color colorbigtext = Color(0xFF030229);
}


class HelpPageAdmin extends StatelessWidget {
  const HelpPageAdmin({
    super.key,
    this.helpText = 'If you have any problems, please contact:',
  });

  final String helpText;

  final List<String> contacts = const [
    "@hlopushkaa - Svetlana Maltseva",
    "@NurKhabib - Nurbek Khabibullin",
    "@komz1k_6 - Daria Komzolova",
    "@kaswhr - Anastasia Kalashnikova",
    "@K_Kris_ssss - Kristina Ushakova",
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorHelpPage,
          ),
        ),
      ),
      drawer: NavBar(currentRoute: currentRoute),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.6;
                final screenWidth = MediaQuery.of(context).size.width;

                final double headerFontSize = screenWidth * 0.05;
                final double bodyFontSize = screenWidth * 0.035;

                return Container(
                  width: width,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(36.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.backgr,
                        offset: const Offset(3.0, 6.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        helpText,
                        style: TextStyle(
                          fontSize: headerFontSize.clamp(18.0, 28.0),
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorHelpPage,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      ...contacts.map(
                        (contact) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            contact,
                            style: TextStyle(
                              fontSize: bodyFontSize.clamp(14.0, 20.0),
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
