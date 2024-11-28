import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assigner/models/assignments_model.dart';
import 'package:assigner/models/students_assignment_model.dart';
import 'package:assigner/models/database_conn.dart';
import 'package:assigner/models/dark_mode_theme.dart';

class AssignmentPage extends StatefulWidget {
  final Assignments assignment;
  final StudentsAssignment stuAss;
  final Function(StudentsAssignment) turnIn;

  AssignmentPage({required this.assignment, required this.stuAss, required this.turnIn});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController _attachController = TextEditingController();
  final DbConn dbConn = DbConn.instance;
  bool? userTurnedIn;
  final _formKey = GlobalKey<FormState>();
  bool isDarkMode = false;
  final DarkModeTheme _darkMode = DarkModeTheme();


  @override
  void initState() {
    super.initState();
    _loadTheme();
    userTurnedIn = widget.stuAss.turnedInBool;
  }

  //Load Dark Mode
  _loadTheme() async {
    bool darkMode = await _darkMode.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }

  //Pop Up Notification Feature
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

  //Function to Turn in Assignment
  void _turnInAssignment() async {
    if (_formKey.currentState!.validate()) {
      String attachment = _attachController.text;
      widget.stuAss.turnedInBool = true;
      widget.stuAss.studentFile = attachment;
      try {
        await dbConn.updateStudentAssignment(widget.stuAss);
        widget.turnIn(widget.stuAss);
        setState(() {
          userTurnedIn = true;
        });
      } catch (e) {
        popUp(context, 'Update failed: $e');
      }
    }
  }


  //Function to undo turned in assignment
  void _undoTurnInAssignment() async {
    widget.stuAss.turnedInBool = false;
    widget.stuAss.studentFile = null;
    try {
      await dbConn.updateStudentAssignment(widget.stuAss);
      widget.turnIn(widget.stuAss);
      setState(() {
        userTurnedIn = false;
      });
    } catch (e) {
      popUp(context, 'Update failed: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    DateTime dueDate = DateTime.parse(widget.assignment.assignmentDate);
    String formattedDate = DateFormat('dd MMMM yyyy, HH:mm:ss').format(dueDate);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[500],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[500],
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
            padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.assignment.assignmentTitle,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[700] : Colors.black
                    ),
                  ),
                  if (!userTurnedIn!)
                  ElevatedButton(
                    onPressed: () {
                      _turnInAssignment();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 60),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isDarkMode ? Colors.green[700] : Colors.green[500],
                    ),
                    child: const Text('Turn In',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                  if (userTurnedIn!)
                    ElevatedButton(
                      onPressed: () {
                        _undoTurnInAssignment();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(140, 60),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isDarkMode ? Colors.green[900] : Colors.green[800],
                      ),
                      child: const Text('Undo Turn In',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 60,),
              Text(
                "Created by: ${widget.assignment.assignmentCreator}",
                style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.blue[800] : Colors.blue[600],
              ),
              ),
              const SizedBox(height: 24,),
              Text(
                formattedDate, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey,
              ),
              ),
              const SizedBox(height: 8,),
              widget.stuAss.grade != null ?
              Text('Grade: ${widget.stuAss.grade}/100',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[600] : Colors.black38
                ),
              )
                  : Text('Grade: Not assigned yet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[600] : Colors.black38
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.assignment.assignmentDesc,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[700] : Colors.black,
                ),
              ),
              const SizedBox(height: 32,),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[600],
                    border: Border.all(
                        width: 2,
                        color: Colors.black
                    )
                ),
                child: Padding(padding: const EdgeInsets.all(8),
                  child: widget.assignment.assignmentFile!.isNotEmpty ?
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.assignment.assignmentFile!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 72,),
                      const Icon(
                        Icons.file_present_rounded,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ],
                  ) : null
                ),
              ),
              const SizedBox(height: 54,),
              Text(
                "Attached Student File",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8,),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[600],
                    border: Border.all(
                        width: 2,
                        color: Colors.black
                    )
                ),
                child: Padding(padding: const EdgeInsets.all(8),
                    child: widget.stuAss.studentFile != null ?
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.stuAss.studentFile!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 72,),
                        const Icon(
                          Icons.file_present_rounded,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ],
                    ) : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "No attached files",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.red[900] : Colors.red,
                          ),
                        ),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 64,),
              if (!userTurnedIn!)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Attach File",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _attachController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please attach a file';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Attach file',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36),
                            borderSide: BorderSide.none),
                        fillColor: Colors.blue.withOpacity(0.2),
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}