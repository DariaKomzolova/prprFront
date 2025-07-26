import 'package:flutter/material.dart';
import 'package:loginsso/admin_panel/models/elective.dart';

class ElectiveCard extends StatefulWidget {
  final Elective elective;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ElectiveCard({
    super.key,
    required this.elective,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ElectiveCard> createState() => _ElectiveCardState();
}

class _ElectiveCardState extends State<ElectiveCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.elective;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text(e.course, style: const TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text(e.instructor)),
                Expanded(flex: 2, child: Text(e.type)),
                Expanded(flex: 3, child: Text(e.years.join(', '))),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: widget.onEdit,
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
                      widget.onDelete();
                    }
                  },
                ),
              ],
            ),
            if (e.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF605BFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    child: Text(isExpanded ? 'Hide description' : 'Show description'),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(e.description),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
