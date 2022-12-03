import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_demo/model.dart';

import 'user_repository.dart';

class SembastUserRepository extends UserRepository {
  static final Database database = GetIt.I.get();
  static final StoreRef store = intMapStoreFactory.store("user_store");

  @override
  Future<int> insertUser(Details user) async {
    return await store.add(database, user.toMap());
  }

  @override
  Future updateUser(Details user) async {
    await store.record(user.id).update(database, user.toMap());
  }

  @override
  Future deleteUser(int userId) async {
    await store.record(userId).delete(database);
  }

  @override
  Future<List<Details>> getAllUsers() async {
    final snapshots = await store.find(database);
    return snapshots
        .map((snapshot) => Details.fromMap(snapshot.key, snapshot.value))
        .toList(growable: true);
  }
}
