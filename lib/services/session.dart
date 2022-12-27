import 'package:hive_flutter/hive_flutter.dart';
import 'package:kasir_cerdas/model/profile.dart';

class Session {
  static late Box<dynamic> _box;
  static String key = 'key';
  static Profile? _user;

  static init() async => _box = await Hive.openBox(key);

  static login(Map<String, dynamic> data) => _box.put(key, data);

  static logout() => _box.clear();

  static set user(Profile user) {
    _user = user;
    _box.put('data', user.toJson());
  }

  static Profile get user {
    if (_user != null) return _user!;
    return Profile.fromJson(Map<String, dynamic>.from(_box.get(key)));
  }
}
