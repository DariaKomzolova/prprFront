import 'package:flutter/material.dart';
import 'package:loginsso/student_panel/models/elective.dart';
import 'package:provider/provider.dart';
import 'package:loginsso/student_panel/providers/elective_provider_student.dart';
import 'package:loginsso/login/app_state.dart';

class ElectiveCardStudent extends StatefulWidget {
  final Elective elective;

  const ElectiveCardStudent({super.key, required this.elective});

  @override
  State<ElectiveCardStudent> createState() => _ElectiveCardStudentState();
}

class _ElectiveCardStudentState extends State<ElectiveCardStudent> {
  bool showDescription = false;
  String? localError;

  @override
  Widget build(BuildContext context) {
    final e = widget.elective;
    final provider = Provider.of<ElectivesProviderStudent>(context);

    final selectedMap = e.type == 'Tech' ? provider.selectedTech : provider.selectedHum;
    final selectedPriority = selectedMap[e.id];

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.course, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Instructor: ${e.instructor}'),
            Text('Type: ${e.type}'),
            Text('Years: ${e.years.join(', ')}'),
            const SizedBox(height: 12),
            SizedBox(
  width: 90, 
  child: DropdownButton<int>(
    dropdownColor: Colors.white,
    value: selectedPriority,
    hint: const Text('Select priority'),
    isExpanded: true, 
    items: List.generate(5, (i) => i + 1).map((priority) {
      return DropdownMenuItem<int>(
        value: priority,
        child: Text('Priority $priority'),
      );
    }).toList(),
    onChanged: (value) {
      if (value != null) {
        final isDuplicatePriority = provider.all.any((other) =>
            other.id != e.id &&
            other.type == e.type &&
            ((e.type == 'Tech'
                ? provider.selectedTech[other.id]
                : provider.selectedHum[other.id]) == value));

        if (isDuplicatePriority) {
          setState(() {
            localError = 'You already selected priority $value for another ${e.type} elective.';
          });
        } else {
          if (e.type == 'Tech') {
            provider.selectTech(e.id, value);
          } else {
            provider.selectHum(e.id, value);
          }
          setState(() {
            localError = null;
          });
        }
      }
    },
  ),
),

            const SizedBox(height: 12),
            if (selectedPriority != null)
              ElevatedButton(
                onPressed: () {
  if (e.type == 'Tech') {
    provider.removeTech(e.id);
  } else {
    provider.removeHum(e.id);
  }

  setState(() {
    localError = null;
  });
},


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Remove selection'),
              ),
            if (e.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showDescription = !showDescription;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: Text(showDescription ? 'Hide description' : 'Show description'),
                ),
              ),
            if (showDescription)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  e.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            if (localError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  localError!,
                  style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
