import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  //Con llaves significa que es posicional:
  /**
   * No hace falta ponerlos en orden. Pones el nombre de la variable y :  ej. ( email: "" )
   * 
  */
  Usuario(
      {
      required this.email,
      required this.password});
}
