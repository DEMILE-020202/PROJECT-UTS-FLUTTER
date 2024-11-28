import 'package:assigner/pages/assignment_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assigner/pages/profile-page.dart';
import 'package:assigner/pages/setting_page.dart';
import 'package:assigner/pages/assignment_page.dart';
import 'package:assigner/models/database_conn.dart';
import 'package:assigner/models/assignments_model.dart';
import 'package:assigner/models/students_assignment_model.dart';
import 'package:assigner/models/dark_mode_theme.dart';


class HomePageStu extends StatefulWidget {
  final Map<String, dynamic> userData;
  HomePageStu({required this.userData});

  @override
  _HomePageStuState createState() => _HomePageStuState();
}

class _HomePageStuState extends State<HomePageStu> {
  TextEditingController _searchController = TextEditingController();
  List<Assignments> assignments = [];
  List<Assignments> filteredAssignments = [];
  List<StudentsAssignment> stuAssignments = [];
  final DbConn dbConn = DbConn.instance;
  bool isDarkMode = false;
  final DarkModeTheme _darkMode = DarkModeTheme();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadAssignments();
    _searchController.addListener(() {
      _filterAssignments();
    });
  }


  //Assignment-related voids
  void _loadAssignments() async {
    final data = await dbConn.getAssignments();
    List<StudentsAssignment> stuAssignments = [];

    filteredAssignments = data;

    for (var assignment in filteredAssignments) {
      final stuAssData = await dbConn.getStudentsForAssignment(assignment.id!);
      stuAssignments.addAll(stuAssData);
    }
    setState(() {
      assignments = filteredAssignments;
      this.stuAssignments = stuAssignments;
    });
  }

  //Function to insert user and assignment id into students_assignment_table
  void _insertStudentAssignment(Assignments assignment) async {
    StudentsAssignment newStuAss = StudentsAssignment(
        studentId: widget.userData['id'],
        assignmentId: assignment.id!
    );
    await dbConn.insertStudentAssignment(newStuAss);
  }

  void _turnIn(StudentsAssignment stuAss) async {
    stuAss.turnedInBool = true;
    await dbConn.insertStudentAssignment(stuAss);
    _loadAssignments();
  }

  void _routeAssignmentPage(Assignments assignment, StudentsAssignment stuAss) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AssignmentPage(
              assignment: assignment,
              stuAss: stuAss,
              turnIn: _turnIn
          )
      ),
    );
  }

  void _filterAssignments() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredAssignments = assignments.where((assignments) {
        return assignments.assignmentTitle.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAssignments);
    _searchController.dispose();
    super.dispose();
  }

  //Dark Mode-related void
  _loadTheme() async {
    bool darkMode = await _darkMode.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black45 : Colors.white70,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.all(16),),
                    Text(
                      "Hello ${widget.userData['username']}",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.blue[900] : Colors.lightBlue),
                    ),
                    const Padding(padding: EdgeInsets.all(8),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buttonRows(Icons.person, "Profile"),
                        _buttonRows(Icons.settings, "Settings"),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search assignment",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 4,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Assignments",
                  style: TextStyle(fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blue[900] : Colors.blueAccent,
                  ),
                ),
              ),
              Divider(
                color: isDarkMode ? Colors.grey[800] : Colors.white70,
                thickness: 16,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Container(
                  color: isDarkMode ? Colors.grey[700] : Colors.white60,
                  padding: const EdgeInsets.all(8),
                  child: filteredAssignments.isEmpty ? Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No assignments found", style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.grey : Colors.black
                        )
                        ),
                      ]
                    ),
                  ) : ListView.builder(
                    itemCount: filteredAssignments.length,
                    itemBuilder: (context, index) {
                      final data = filteredAssignments[index];
                      final stuAssData = stuAssignments.firstWhere(
                              (sa) => sa.assignmentId == data.id,
                          orElse: () => StudentsAssignment(
                              studentId: widget.userData['id'],
                              assignmentId: data.id!
                          )
                      );
                      final bool isOverdue = data.isOverdue();
                      return Card(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: ListTile(
                          onTap: () {
                            _insertStudentAssignment(data);
                            _routeAssignmentPage(data, stuAssData);
                          },
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: isOverdue ? Colors.red : Colors.blue[300],
                            child: Text(data.assignmentTitle[0]),
                          ),
                          title: Text(data.assignmentTitle,
                            style: TextStyle(
                                color: isDarkMode ? Colors.grey : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Text(data.assignmentDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              Text('Due: ${data.getFormattedDate()}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
              Divider(
                color: isDarkMode ? Colors.grey[800] : Colors.white70,
                thickness: 16,
              ),
            ],
        ),
      ),
      );
  }

    _buttonRows(IconData icon, String label){

    return ElevatedButton(onPressed: () {
      if (label == "Profile") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProfilePage(userData: widget.userData,
            );
          },
        );
      }
      if (label == "Settings") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SettingPage(onDarkMode: () {
                _loadTheme();
              },
            );
            },
        );
      }
    },
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.all(1)),
        shape: const WidgetStatePropertyAll(OvalBorder()),
        fixedSize: const WidgetStatePropertyAll(Size(80, 80)),
        backgroundColor: WidgetStatePropertyAll(isDarkMode ? Colors.grey[900] : Colors.white),
        elevation: const WidgetStatePropertyAll(0),
      ),
    child:
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, color: isDarkMode ? Colors.blue[900] : Colors.blueAccent),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.blue[900] : Colors.blueAccent,
            ),
          ),
        )
      ],
    ),
    );
  }
}
