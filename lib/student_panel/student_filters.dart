import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loginsso/student_panel/providers/elective_provider_student.dart';

class StudentFilters extends StatelessWidget {
  const StudentFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectivesProviderStudent>(context);

    return Column(
      children: [
        TextField(
          controller: provider.searchController,
          onChanged: provider.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            suffixIcon: provider.searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => provider.setSearchQuery(''),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: provider.instructorFilter,
          decoration: const InputDecoration(labelText: 'Instructor'),
          items: provider.availableInstructors
              .map((inst) => DropdownMenuItem(value: inst, child: Text(inst)))
              .toList(),
          onChanged: (val) => provider.setInstructorFilter(val!),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: provider.clearFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF605BFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Clear Filters'),
        ),
      ],
    );
  }
}
