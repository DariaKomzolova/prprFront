import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:loginsso/admin_panel/navbar.dart';
import 'package:loginsso/admin_panel/services/deadline_api_service.dart';


class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgr = Color(0xFFF3F1F1);
  static const Color colorbigtext = Color(0xFF030229);
  static const Color buttonColor = Color(0xFF5F5CFE);
}

class DeadlinesPage extends StatefulWidget {
  const DeadlinesPage({super.key});

  @override
  State<DeadlinesPage> createState() => _DeadlinesPageState();
}

class _DeadlinesPageState extends State<DeadlinesPage> {
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 15);
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 15);

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
    final data = await DeadlineApiService.getDeadline();

    if (data['start'] != null && data['end'] != null) {
      setState(() {
        _startDate = DateTime.parse(data['start']!);
        _endDate = DateTime.parse(data['end']!);
        _isSaved = true;

      });
    }
  } catch (e) {
    debugPrint('Error loading deadline: $e');
  }
  
  }

  Future<void> _saveDeadlines() async { 
     final startDateTime = DateTime(
      _startDate.year, _startDate.month, _startDate.day,
      _startTime.hour, _startTime.minute,
    );
    final endDateTime = DateTime(
      _endDate.year, _endDate.month, _endDate.day,
      _endTime.hour, _endTime.minute,
    );

    if (startDateTime.isAfter(endDateTime)) {
      _showInvalidRangeDialog("Start cannot be after End");
      return;
    }

    try {
      await DeadlineApiService.setDeadline(
        startDateTime.toIso8601String(),
        endDateTime.toIso8601String(),
      );

      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deadlines saved')),
      );
    } catch (e) {
      debugPrint('Error saving deadline: $e');
    }
    /* final prefs = await SharedPreferences.getInstance();
    final date = isStart ? _startDate : _endDate;
    final time = isStart ? _startTime : _endTime;

    final startDateTime = DateTime(
      _startDate.year, _startDate.month, _startDate.day,
      _startTime.hour, _startTime.minute,
    );
    final endDateTime = DateTime(
      _endDate.year, _endDate.month, _endDate.day,
      _endTime.hour, _endTime.minute,
    );

    if (isStart && startDateTime.isAfter(endDateTime)) {
      _showInvalidRangeDialog("The beginning cannot be later than the end!");
      return;
    }

    if (!isStart && endDateTime.isBefore(startDateTime)) {
      _showInvalidRangeDialog("The end cannot be earlier than the beginning!");
      return;
    }

    await prefs.setString(isStart ? 'startDate' : 'endDate', date.toIso8601String());
    await prefs.setInt(isStart ? 'startTimeHour' : 'endTimeHour', time.hour);
    await prefs.setInt(isStart ? 'startTimeMinute' : 'endTimeMinute', time.minute);

    setState(() {
      if (isStart) {
        _isStartSaved = true;
      } else {
        _isEndSaved = true;
      }
    });

    debugPrint('${isStart ? "Start" : "End"} saved: $date ${time.format(context)}'); */
  }

    void _showInvalidRangeDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ок"),
          ),
        ],
      ),
    );
  }


  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _isSaved = false;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _isSaved = false;
      });
    }
  }

  void _startSelection() {
    debugPrint("Electives selection started");
  }

  void _stopSelection() {
    debugPrint("Electives selection stopped");
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgr,
      appBar: AppBar(
        backgroundColor: AppColors.backgr,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Setting deadlines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.colorbigtext,
          ),
        ),
      ),
      drawer: NavBar(currentRoute: currentRoute),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            _buildDeadlineCard(
              context,
              "The beginning of electives selection",
              _startDate,
              _startTime,
              () => _pickDate(context, true),
              () => _pickTime(context, true),

              isSmallScreen,
            ),
            const SizedBox(height: 20),
            _buildDeadlineCard(
              context,
              "End of electives selection",
              _endDate,
              _endTime,
              () => _pickDate(context, false),
              () => _pickTime(context, false),

              isSmallScreen,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isSaved ? null : _saveDeadlines,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSaved ? Colors.grey : AppColors.buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: Text(_isSaved ? "Saved" : "Save deadlines"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton("Start", _startSelection, isSmallScreen),
                _buildActionButton("Stop", _stopSelection, isSmallScreen),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineCard(
    BuildContext context,
    String title,
    DateTime date,
    TimeOfDay time,
    VoidCallback onPickDate,
    VoidCallback onPickTime,

    bool isSmallScreen,
  ) {
    final formattedDate = DateFormat('d MMM, y').format(date);
    final formattedTime = time.format(context);

    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 12 : 16,
          horizontal: isSmallScreen ? 16 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            InkWell(
              onTap: onPickDate,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text(formattedDate),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: onPickTime,
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 8),
                  Text(formattedTime),
                ],
              ),
            ),

          /*   SizedBox(height: isSmallScreen ? 12 : 15),
            ElevatedButton(
              onPressed: isSaved ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSaved ? Colors.grey : AppColors.buttonColor,
                foregroundColor: Colors.white,
              ),
              child: Text(isSaved ? "Saved" : "Save"),
            ), */

          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, bool isSmallScreen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 24 : 40,
          vertical: isSmallScreen ? 10 : 12,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      ),
    );
  }
}
