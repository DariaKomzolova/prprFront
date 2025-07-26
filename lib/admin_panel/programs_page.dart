import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/admin_panel/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loginsso/admin_panel/services/programs_api_service.dart';

import 'package:loginsso/admin_panel/providers/elective_provider.dart';
import 'package:provider/provider.dart' as flutter_provider;



class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorbigtext = Color(0xFF030229);
  static const Color grey = Color(0xFFB0B0B0);
  static const Color primary = Color(0xFF605BFF);
}

class ProgramData {
  String name;
  int? tech;
  int? hum;
  bool isSaved;
  bool isModified;

  ProgramData({
    required this.name,
    this.tech,
    this.hum,
    this.isSaved = false,
    this.isModified = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'tech': tech ?? 0,
    'hum': hum ?? 0,
  };
}

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({Key? key}) : super(key: key);

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  final ProgramsApiService apiService = ProgramsApiService();
  List<ProgramData> programs = [];

  @override
  void initState() {
    super.initState();
    loadPrograms();
  }

  Future<void> loadPrograms() async {
    try {
      final data = await apiService.fetchPrograms();
      setState(() {
        programs = data.map((item) => ProgramData(
          name: item['name'],
          tech: item['tech'],
          hum: item['hum'],
          isSaved: true,
          isModified: false,
        )).toList();
      });
    } catch (e) {
      print('Error loading programs: $e');
    }
  }

  void addProgram() async {
    final provider = flutter_provider.Provider.of<ElectivesProviderAdmin>(context, listen: false);

    setState(() async {
      programs.add(ProgramData(name: 'New_Program'));
    });

    await provider.fetchAvailablePrograms();
  }

  Future<void> deleteProgram(ProgramData program) async {
    final provider = flutter_provider.Provider.of<ElectivesProviderAdmin>(context, listen: false);

    if (program.isSaved) {
      await apiService.deleteProgram(program.name);
      await provider.fetchAvailablePrograms();
    }
    setState(() {
      programs.remove(program);
    });
  }

  Future<void> saveProgram(ProgramData program) async {
    final provider = flutter_provider.Provider.of<ElectivesProviderAdmin>(context, listen: false);

    if (program.isSaved) {
      await apiService.updateProgram(program.name, program.toJson());
    } else {
      await apiService.createProgram(program.toJson());
    }

    await provider.fetchAvailablePrograms();

    setState(() {
      program.isSaved = true;
      program.isModified = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    return Scaffold(
      backgroundColor: AppColors.backgr,
      drawer: NavBar(currentRoute: currentRoute),
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Setting programs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorbigtext,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter the number of elective subjects for each program',
              style: TextStyle(fontSize: 18, color: AppColors.colorbigtext),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  return ProgramTile(
                    program: programs[index],
                    onSave: () => saveProgram(programs[index]),
                    onDelete: () => deleteProgram(programs[index]),
                    onChanged: () => setState(() {}),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: addProgram,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('+ Add a program'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgramTile extends StatefulWidget {
  final ProgramData program;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const ProgramTile({
    Key? key,
    required this.program,
    required this.onSave,
    required this.onDelete,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProgramTile> createState() => _ProgramTileState();
}

class _ProgramTileState extends State<ProgramTile> {
  late TextEditingController nameController;
  late TextEditingController techController;
  late TextEditingController humController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.program.name);
    techController = TextEditingController(text: widget.program.tech?.toString() ?? '');
    humController = TextEditingController(text: widget.program.hum?.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    techController.dispose();
    humController.dispose();
    super.dispose();
  }

  void updateProgram() {
    setState(() {
      widget.program.name = nameController.text;
      widget.program.tech = int.tryParse(techController.text) ?? 0;
      widget.program.hum = int.tryParse(humController.text) ?? 0;
      widget.program.isModified = true;
      widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Program Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => updateProgram(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: techController,
                decoration: const InputDecoration(
                  labelText: 'Technical electives',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => updateProgram(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: humController,
                decoration: const InputDecoration(
                  labelText: 'Humanitarian electives',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => updateProgram(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: widget.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.program.isModified
                    ? AppColors.primary
                    : AppColors.grey,
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (widget.program.isSaved)
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
      ),
    );
  }
}
