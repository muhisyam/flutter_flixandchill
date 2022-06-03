import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  UserModel({required this.username, required this.password});

  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @override
  String toString() {
    return 'UserModel{fullname: $username,password: $password}';
  }
}
