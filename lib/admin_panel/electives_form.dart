import 'package:flutter/material.dart';
import 'providers/elective_provider.dart';
import 'package:provider/provider.dart';


class ElectiveForm extends StatefulWidget {
  const ElectiveForm({super.key});

  @override
  State<ElectiveForm> createState() => _ElectiveFormState();
}

class _ElectiveFormState extends State<ElectiveForm> {
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectivesProviderAdmin>(context);
    final availablePrograms = provider.availablePrograms;

    return Form(
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
        FormField<List<String>>(
          initialValue: provider.selectedCourses,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select at least one year';
            }
            return null;
          },
          builder: (state) {
            return InputDecorator(
              decoration: inputDecoration('Programs').copyWith(
                errorText: state.errorText,
              ),
              child: Wrap(
                spacing: 6,
                children: availablePrograms.map((year) {
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
                      state.didChange(updated);
                    },
                  );
                }).toList(),
              ),
            );
          },
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
          onPressed: () async {
            await provider.saveElective();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF605BFF),
            foregroundColor: Colors.white,
            minimumSize: const Size(140, 36),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: Text(provider.editingIndex != null ? 'Update' : 'Save'),
        ),
      ]),
    );
  }
}
