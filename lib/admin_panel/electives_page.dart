import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:loginsso/admin_panel/providers/elective_provider.dart';
import 'package:loginsso/admin_panel/navbar.dart';
import 'package:loginsso/admin_panel/electives_form.dart';
import 'package:loginsso/admin_panel/models/elective.dart';

class AppColors {
  static const Color colorHelpPage = Color(0xFF030229);
}

class ElectivesPageAdmin extends StatefulWidget {
  const ElectivesPageAdmin({super.key});

  @override
  State<ElectivesPageAdmin> createState() => _ElectivesPageAdminState();
}

class _ElectivesPageAdminState extends State<ElectivesPageAdmin> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = Provider.of<ElectivesProviderAdmin>(context, listen: false);
      provider.fetchAvailablePrograms(); 
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ElectivesPageAdminBody();
  }
}

class ElectivesPageAdminBody extends StatelessWidget {
  const ElectivesPageAdminBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ElectivesProviderAdmin>(
      builder: (context, provider, _) {
        final electives = provider.filteredElectives;
        final currentRoute = GoRouterState.of(context).uri.toString();

        final ScrollController scrollController = ScrollController();

        void scrollToForm() {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF3F1F1),
          drawer: NavBar(currentRoute: currentRoute),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Electives',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.colorHelpPage,
              ),
            ),
            backgroundColor: const Color(0xFFF3F1F1),
            elevation: 0,
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300, 
                          child: TextField(
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
                                      onPressed: () {
                                        provider.setSearchQuery('');
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: DropdownButtonFormField<String>(
                                value: provider.typeFilter,
                                decoration: const InputDecoration(labelText: 'Type'),
                                items: ['All', 'Tech', 'Hum'].map((type) {
                                  return DropdownMenuItem(value: type, child: Text(type));
                                }).toList(),
                                onChanged: (val) => provider.setTypeFilter(val!),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: DropdownButtonFormField<String>(
                                value: provider.instructorFilter,
                                decoration: const InputDecoration(labelText: 'Instructor'),
                                items: provider.availableInstructors.map((inst) {
                                  return DropdownMenuItem(value: inst, child: Text(inst));
                                }).toList(),
                                onChanged: (val) => provider.setInstructorFilter(val!),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: DropdownButtonFormField<String>(
                                value: provider.yearFilter,
                                decoration: const InputDecoration(labelText: 'Programs'),
                                items: provider.availableYears.map((year) {
                                  return DropdownMenuItem(value: year, child: Text(year));
                                }).toList(),
                                onChanged: (val) => provider.setYearFilter(val!),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                   
                            ElevatedButton(
                              onPressed: provider.clearFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF605BFF),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(120, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Clear Filters'),
                            ),

                            const Spacer(),


                            if (provider.showForm)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: provider.cancelEditing,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black87,
                                    minimumSize: const Size(120, 36),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),

                     
                            ElevatedButton(
                              onPressed: () {
                                provider.toggleFormVisibility();
                                scrollToForm();
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
                              child: const Text('+Add Elective'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

          
                if (provider.showForm)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: const ElectiveForm(),
                    ),
                  ),
                const SizedBox(height: 16),

            
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: electives.length,
                  itemBuilder: (context, index) {
                    final e = electives[index];
                    return ElectiveCard(
                      elective: e,
                      index: index,
                      onEdit: () {
                        provider.startEditing(index);
                        scrollToForm();
                      },
                      onDelete: () => provider.removeElectiveById(e.id),

                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


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
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
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
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: MarkdownBody(
                        data: e.description,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
