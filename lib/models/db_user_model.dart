// User class database model

class User {
  int userID;
  String username;
  String password;
  String fName;
  String lName;
  String email;
  int isAdmin;

  User({
    required this.userID,
    required this.username,
    required this.password,
    required this.fName,
    required this.lName,
    required this.email,
    required this.isAdmin,
  });

  // Get a User from json
  factory User.fromJson(Map<String, dynamic> json) => User(
        userID: json['userID'],
        username: json['username'],
        password: json['password'],
        fName: json['fName'],
        lName: json['lName'],
        email: json['email'],
        isAdmin: json['isAdmin'],
      );

  // Create json from a User
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'username': username,
        'password': password,
        'fName': fName,
        'lName': lName,
        'email': email,
        'isAdmin': isAdmin,
      };

  // Convert a User into a Map. The keys must correspond
  // to the names of the columns in the database.
  Map<String, Object?> toMap() {
    return {
      'userID': userID,
      'username': username,
      'password': password,
      'fName': fName,
      'lName': lName,
      'email': email,
      'isAdmin': isAdmin,
    };
  }

  // Implement toString to make it easier to see info about
  // each dog when using the print stmt.
  @override
  String toString() {
    return 'User{'
        'userID: $userID, '
        'username: $username, '
        'password: $password, '
        'fName: $fName, '
        'lName: $lName, '
        'email: $email, '
        'isAdmin: $isAdmin'
        '}';
  }
}
