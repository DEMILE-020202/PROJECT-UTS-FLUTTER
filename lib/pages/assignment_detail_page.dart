import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assigner/models/assignments_model.dart';
import 'package:assigner/models/students_assignment_model.dart';
import 'package:assigner/models/database_conn.dart';
import 'package:assigner/models/dark_mode_theme.dart';


class AssignmentDetailPage extends StatefulWidget {
  final Assignments assignment;
  final StudentsAssignment stuAss;
  final Function(Assignments) delete;
  final VoidCallback refreshList;

  AssignmentDetailPage({required this.assignment, required this.stuAss,required this.delete, required this.refreshList});

  @override
  _AssignmentDetailPageState createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final TextEditingController gradeController = TextEditingController();
  final DbConn dbConn = DbConn.instance;
  bool isDarkMode = false;
  final DarkModeTheme _darkMode = DarkModeTheme();


  //Pop Up Notification feature
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


  //Confirmation notification when pressing delete button
  void deleteConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text("Are you sure you want to delete this assignment?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _deleteAssignment();
                  },
                  child: const Text("Delete",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
          );
        }
    );
  }

  @override void initState() {
    super.initState();
    _loadTheme();
    gradeController.text = widget.stuAss.grade?.toString() ?? '';
  }


  //Load Dark Mode
  _loadTheme() async {
    bool darkMode = await _darkMode.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }


  //Function to input and assign grade
  void _inputGrade() {
    int? grade = int.tryParse(gradeController.text);
    if (grade == null || grade < 0 || grade > 100) {
      popUp(context, 'Input must be digits between 0 and 100');
    }

    setState(() {
      widget.stuAss.grade = grade;
    });

    dbConn.updateAssignment(widget.assignment);
    popUp(context, 'Assignment has been graded');
  }


  //Function to delete assignment
  void _deleteAssignment() async {
    try {
      await dbConn.deleteAssignment(widget.assignment.id!);
      widget.delete(widget.assignment);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      widget.refreshList();
    } catch (e) {
      popUp(context, 'Deletion failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.assignment.assignmentDate);
    String formattedDate = DateFormat('dd MMMM yyyy, HH:mm:ss').format(date);

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
                      ElevatedButton(
                          onPressed: () {
                            deleteConfirmation(context);
                          },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(140, 60),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isDarkMode ? Colors.red[900] : Colors.red[600],
                        ),
                          child: const Text('Delete',
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
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.grey[600] : Colors.black38
                        ),
                    )
                  : Text('Grade: Not assigned yet',
                    style: TextStyle(
                        fontSize: 22,
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
                  const SizedBox(height: 92,),
                  if (widget.stuAss.turnedInBool)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Grade assignment",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      TextField(
                        controller: gradeController,
                        decoration: InputDecoration(
                          labelText: 'Grade assignment (0/100)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(36),
                              borderSide: BorderSide.none),
                          fillColor: Colors.blue.withOpacity(0.2),
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24,),
                      ElevatedButton(
                        onPressed: () {
                          _inputGrade();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(180, 60),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Grade',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        )
    );
  }
}