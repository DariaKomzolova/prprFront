import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/student_panel/navbar.dart';
import 'package:loginsso/presentation/colors/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:loginsso/student_panel/providers/elective_provider_student.dart';
import 'package:loginsso/student_panel/models/elective.dart';
import 'package:collection/collection.dart';
import 'package:loginsso/login/app_state.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appState = Provider.of<AppState>(context, listen: false);
      final provider = Provider.of<ElectivesProviderStudent>(context, listen: false);
      await provider.loadElectives(appState.year!);
      await provider.reloadChoices(appState.email!);
      await provider.loadDeadline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final provider = Provider.of<ElectivesProviderStudent>(context);

    final tech = provider.all.where((e) => e.type == 'Tech' && provider.selectedTech.containsKey(e.id)).toList();
    final hum = provider.all.where((e) => e.type == 'Hum' && provider.selectedHum.containsKey(e.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        title: const Text(
          'Main',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textBlack,
          ),
        ),
      ),
      drawer: StudentNavBar(currentRoute: currentRoute),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _instructionCard(),

              const SizedBox(height: 16),

              if (provider.deadlineStart != null && provider.deadlineEnd != null)
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Voting starts: ${provider.deadlineStart!.substring(0, 10)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Voting ends: ${provider.deadlineEnd!.substring(0, 10)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _selectedElectivesCard("Technical Electives", tech, provider.selectedTech)),
                  const SizedBox(width: 16),
                  Expanded(child: _selectedElectivesCard("Humanitarian Electives", hum, provider.selectedHum)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _instructionCard() {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            "Dear student! Below you can see your selected electives.\n"
            "To change your choices, please go to the Technical or Humanitarian pages.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedElectivesCard(String title, List<Elective> electives, Map<String, int> selectedMap) {
    final selectedPriorities = selectedMap.values.toSet();
    final missingPriorities = [1, 2, 3, 4, 5].where((p) => !selectedPriorities.contains(p)).toList();

    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final priority = index + 1;
              final elective = electives.firstWhereOrNull((e) => selectedMap[e.id] == priority);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Priority $priority: ${elective != null ? elective.course : "Not selected"}",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }),
            const SizedBox(height: 16),
            if (missingPriorities.isEmpty)
              const Text(
                "✅ You have selected all 5 priorities.",
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              )
            else
              Text(
                "⚠️ Please select priorities: ${missingPriorities.join(', ')}.",
                style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
