
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:loginsso/student_panel/providers/elective_provider_student.dart';
import 'package:loginsso/student_panel/navbar.dart';
import 'package:loginsso/login/app_state.dart';
import 'package:loginsso/student_panel/student_card.dart';
import 'package:loginsso/presentation/colors/app_colors.dart';

class HumElectivesPage extends StatefulWidget {
  const HumElectivesPage({super.key});

  @override
  State<HumElectivesPage> createState() => _HumElectivesPageState();
}

class _HumElectivesPageState extends State<HumElectivesPage> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ElectivesProviderStudent>(context, listen: false);
    searchController = TextEditingController(text: provider.searchQuery);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      provider.loadElectives(appState.year!);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectivesProviderStudent>(context);
    final appState = Provider.of<AppState>(context, listen: false);
    final email = appState.email!;

    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        title: const Text(
          'Humanitarian Electives',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.textBlack),
        ),
      ),
      drawer: StudentNavBar(currentRoute: '/student/humanitarian'),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by course, instructor, or description',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  provider.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => provider.setSearchQuery(value),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: provider.humElectives.map((e) => ElectiveCardStudent(elective: e)).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: provider.isSubmittedHum
                      ? null
                      : () async {
                          await provider.submitHumChoices();
                          await provider.reloadChoices(email);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Humanitarian choices saved!')),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isSubmittedHum ? Colors.grey : const Color(0xFF625BFF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save my Humanitarian Choice'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(
            width: 320,
            child: _selectedElectivesSidebar(provider),
          ),
        ],
      ),
    );
  }

  Widget _selectedElectivesSidebar(ElectivesProviderStudent provider) {
    final selected = provider.selectedHum;
    final electives = provider.all.where((e) => e.type == 'Hum' && selected.containsKey(e.id)).toList();
    electives.sort((a, b) => selected[a.id]!.compareTo(selected[b.id]!));

    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Humanitarian Choices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List.generate(5, (index) {
              final priority = index + 1;
              final elective = electives.firstWhereOrNull((e) => selected[e.id] == priority);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "Priority $priority: ${elective != null ? elective.course : "Not selected"}",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
    