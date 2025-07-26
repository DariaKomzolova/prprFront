import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/elective_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/instructor_panel/navbar.dart';

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

class ElectivesPageInstructor extends StatelessWidget {
  const ElectivesPageInstructor({super.key});

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ElectivesProviderInstr>();
    final electives = provider.electives;
    final currentRoute = GoRouterState.of(context).uri.toString();

    const availableCourses = [
      'BS1_EN',
      'BS2_EN',
      'BS1_RU',
      'BS2_RU',
      'MS_SD',
    ];

    return Scaffold(
      backgroundColor: AppColors.backgr,
      drawer: InstructorNavBar(currentRoute: currentRoute),
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Electives',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorHelpPage,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          if (provider.showForm)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: provider.cancelEditing,
                child: const Text('Cancel'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.purpleButtonColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: provider.toggleFormVisibility,
              child: const Text('+Add Elective'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (provider.showForm)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: provider.formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: provider.courseController,
                        decoration: inputDecoration('Course'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: provider.instructorController,
                        decoration: inputDecoration('Instructor'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: provider.selectedType,
                        decoration: inputDecoration('Tech/Hum'),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(value: 'Tech', child: Text('Tech')),
                          DropdownMenuItem(value: 'Hum', child: Text('Hum')),
                        ],
                        onChanged: provider.setSelectedType,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      InputDecorator(
                        decoration: inputDecoration('Years'),
                        child: Wrap(
                          spacing: 6,
                          children: availableCourses.map((year) {
                            final isSelected = provider.selectedCourses.contains(year);
                            return FilterChip(
                              label: Text(year),
                              selected: isSelected,
                              onSelected: (selected) {
                                final updated = List<String>.from(provider.selectedCourses);
                                if (selected) {
                                  updated.add(year);
                                } else {
                                  updated.remove(year);
                                }
                                provider.setSelectedCourses(updated);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: provider.descriptionController,
                        decoration: inputDecoration('Description'),
                        maxLines: 9,
                        minLines: 7,
                        keyboardType: TextInputType.multiline,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: provider.saveElective,
                        child: const Text('Save'),
                      ),
                    ]),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Course',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Instructor',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tech/Hum',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Years',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: electives.length,
              itemBuilder: (context, index) {
                final e = electives[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(flex: 3, child: Text(e.course, textAlign: TextAlign.start)),
                          Expanded(flex: 3, child: Text(e.instructor, textAlign: TextAlign.start)),
                          Expanded(flex: 3, child: Text(e.type, textAlign: TextAlign.start)),
                          Expanded(flex: 2, child: Text(e.years.join(', '), textAlign: TextAlign.start)),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              provider.startEditing(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text('Do you really want to delete?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                provider.removeElective(index);
                              }
                            },
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: Text(e.description),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
