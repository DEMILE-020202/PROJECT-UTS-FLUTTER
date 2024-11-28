import 'package:intl/intl.dart';

class Assignments {
  int? id;
  String assignmentTitle;
  String assignmentCreator;
  String assignmentDesc;
  String assignmentDate;
  String? assignmentFile;

  Assignments({
    this.id,
    required this.assignmentTitle,
    required this.assignmentCreator,
    required this.assignmentDesc,
    required this.assignmentDate,
    this.assignmentFile,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': assignmentTitle,
      'creator': assignmentCreator,
      'description': assignmentDesc,
      'dueDate': assignmentDate,
      'file': assignmentFile,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Assignments.fromMap(Map<String, dynamic> map){
    return Assignments(
      id: map['id'],
      assignmentTitle: map['title'],
      assignmentCreator: map['creator'],
      assignmentDesc: map['description'],
      assignmentDate: map['dueDate'],
      assignmentFile: map['file'],
    );
  }

  bool isOverdue() {
    DateTime now = DateTime.now();
    DateTime dueDate = DateTime.parse(assignmentDate);
    return now.isAfter(dueDate);
  }

  String getFormattedDate() {
    DateTime date = DateTime.parse(assignmentDate);
    return DateFormat('dd MMMM yyyy').format(date);
  }
}

