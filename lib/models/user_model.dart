class User{
  int? id;
  String username;
  String email;
  String password;
  String profession;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profession
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'profession': profession,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      profession: map['profession'],
    );
  }
}