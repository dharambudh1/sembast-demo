import 'model.dart';

abstract class UserRepository {
  Future<int> insertUser(Details user);

  Future updateUser(Details user);

  Future deleteUser(int userId);

  Future<List<Details>> getAllUsers();
}
