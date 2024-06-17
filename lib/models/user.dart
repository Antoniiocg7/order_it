
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  Usuario(
      {
      required this.email,
      required this.password});
}
