import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_demo/sembast_user_repository.dart';

import 'user_repository.dart';

class Init {
  static Future initialize() async {
    await _initSembast();
    _registerRepositories();
  }

  static _registerRepositories() {
    GetIt.I
        .registerLazySingleton<UserRepository>(() => SembastUserRepository());
    if (kDebugMode) {
      print("after register repository");
    }
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "sembast.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }
}
