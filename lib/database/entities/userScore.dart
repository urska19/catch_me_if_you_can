import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class UserScore {
  String name;
  int score;

  UserScore({required this.name, required this.score});

  // Convert a UserScore into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
    };
  }

  factory UserScore.fromMap(Map<String, dynamic> map) {
    return UserScore(
        name: map['name'] as String,
        score: map['score'] as int);
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'UserScore{name: $name, score: $score}';
  }

}
