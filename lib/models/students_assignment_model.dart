class StudentsAssignment {
  int? id;
  int studentId;
  int assignmentId;
  String? studentFile;
  bool turnedInBool;
  int? grade;
  String? comment;

  StudentsAssignment({
    this.id,
    required this.studentId,
    required this.assignmentId,
    this.studentFile,
    this.turnedInBool = false,
    this.grade,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'studentId': studentId,
      'assignmentId': assignmentId,
      'studentFile': studentFile,
      'turnedInBool': turnedInBool ? 1 : 0,
      'grade': grade,
      'comment': comment,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory StudentsAssignment.fromMap(Map<String, dynamic> map) {
    return StudentsAssignment(
      id: map['id'],
      studentId: map['studentId'],
      assignmentId: map['assignmentId'],
      studentFile: map['studentFile'],
      turnedInBool: map['turnedInBool'] == 1,
      grade: map['grade'],
      comment: map['comment'],
    );
  }
}