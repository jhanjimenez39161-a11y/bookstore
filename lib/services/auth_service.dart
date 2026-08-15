import '../database/database_helper.dart';

class AuthService {
  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<bool> registrarUsuario(
    String correo,
    String password,
  ) async {
    try {
      await _database.insertarUsuario(correo, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> iniciarSesion(
    String correo,
    String password,
  ) async {
    final usuario = await _database.buscarUsuario(
      correo,
      password,
    );

    return usuario != null;
  }
}