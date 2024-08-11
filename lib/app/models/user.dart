import 'package:vania/vania.dart';

class User extends Model {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? salt;
  final int? parallelism;
  final int? memorySize;
  final int? iterations;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.salt,
    this.parallelism,
    this.memorySize,
    this.iterations,
  }) {
    super.table('users');
  }

  factory User.fromRequestJson(Map<String, dynamic> json) => switch (json) {
        {
          'name': final String name,
          'email': final String email,
          'password': final String password,
        } =>
          User(
            name: name,
            email: email,
            password: password,
          ),
        _ => throw ArgumentError('Invalid User.fromRequestJson'),
      };

  factory User.fromDbJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'email': final String email,
          'password': final String password,
          'salt': final String salt,
          'parallelism': final int parallelism,
          'memory_size': final int memorySize,
          'iterations': final int iterations,
        } =>
          User(
            id: id,
            name: name,
            email: email,
            password: password,
            salt: salt,
            parallelism: parallelism,
            memorySize: memorySize,
            iterations: iterations,
          ),
        _ => throw ArgumentError('Invalid User.fromDbJson'),
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'salt': salt,
      'parallelism': parallelism,
      'memory_size': memorySize,
      'iterations': iterations,
    }..removeWhere((_, value) => value == null);
  }

  Map<String, dynamic> toFriendlyMap() {
    return {
      'name': name,
      'email': email,
    }..removeWhere((_, value) => value == null);
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? salt,
    int? parallelism,
    int? memorySize,
    int? iterations,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      salt: salt ?? this.salt,
      parallelism: parallelism ?? this.parallelism,
      memorySize: memorySize ?? this.memorySize,
      iterations: iterations ?? this.iterations,
    );
  }
}
