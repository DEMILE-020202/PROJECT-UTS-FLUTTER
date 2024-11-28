import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assigner/models/assignments_model.dart';
import 'package:assigner/models/database_conn.dart';
import 'package:assigner/models/dark_mode_theme.dart';

class AssignmentCreationPage extends StatefulWidget {
  final String creator;
  final VoidCallback refreshList;

  AssignmentCreationPage({required this.creator, required this.refreshList});

  @override
  _AssignmentCreationPageState createState() => _AssignmentCreationPageState();
}

class _AssignmentCreationPageState extends State<AssignmentCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();
  DateTime? dueDate;
  final _formKey = GlobalKey<FormState>();
  final DbConn dbConn = DbConn.instance;
  bool isDarkMode = false;
  final DarkModeTheme _darkMode = DarkModeTheme();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    bool darkMode = await _darkMode.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }

  void popUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(
            fontSize: 24,
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _createAssignment() async {
    if (_formKey.currentState!.validate()) {
    String title = _titleController.text;
    String creator = widget.creator;
    String description = _descController.text;
    String file = _fileController.text;
    if (dueDate == null) {
      popUp(context, 'Due date cannot be null');
    }
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dueDate!);

    Assignments newAssignment = Assignments(
        assignmentTitle: title,
        assignmentCreator: creator,
        assignmentDesc: description,
        assignmentDate: formattedDate,
        assignmentFile: file
    );

    try {
      await dbConn.insertAssignment(newAssignment);
      Navigator.pop(context);
      widget.refreshList();
    } catch (e) {
      popUp(context, 'Creation failed: $e');
    }
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: dueDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (datePicked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dueDate ?? DateTime.now()),
      );
      if (timePicked != null) {
        setState(() {
          dueDate = DateTime(
              datePicked.year,
              datePicked.month,
              datePicked.day,
              timePicked.hour,
              timePicked.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: isDarkMode ? Colors.grey[400] : Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Create New Assignment", style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey),
                ),
                const SizedBox(height: 47,),
                Text("Title", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey[700] : Colors.black),
                ),
                const SizedBox(height: 6,),
                TextFormField(
                  controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the title';
                      }
                    },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.2),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 24,),
                Text("Description", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey[700] : Colors.black),
                ),
                const SizedBox(height: 6,),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.2),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 24,),
                Text(
                  "Due Date",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey[700] : Colors.black),
                ),
                const SizedBox(height: 6,),
                ElevatedButton(
                  onPressed: () => _selectDueDate(context),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    backgroundColor: Colors.blue.withOpacity(0.2),
                  ),
                  child: Text(dueDate == null
                      ? "Due Date"
                      : DateFormat("dd MMMM yyyy, HH:mm").format(dueDate!),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black),
                  ),
                ),
                const SizedBox(height: 24,),
                Text("File Attachment", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey[700] : Colors.black),
                ),
                const SizedBox(height: 6,),
                TextFormField(
                  controller: _fileController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.2),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 108,),
                ElevatedButton(
                  onPressed: _createAssignment,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isDarkMode ? Colors.blue[900] :Colors.blue,
                  ),
                  child: const Text('Create New Assignment',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
      ),
    );
  }
}