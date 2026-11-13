import 'dart:convert';
import 'dart:io';

class LocalStore {
  static File get _file {
    if (Platform.isAndroid) {
      return File(
          '/data/user/0/com.albarkat.fruit_mandi_app/files/mandi_v1.json');
    }
    return File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}mandi_v1.json');
  }

  static Future<Map<String, dynamic>?> load() async {
    try {
      final f = _file;
      if (!await f.exists()) return null;
      final txt = await f.readAsString();
      return jsonDecode(txt) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(Map<String, dynamic> data) async {
    try {
      final f = _file;
      if (!await f.parent.exists()) {
        await f.parent.create(recursive: true);
      }
      await f.writeAsString(jsonEncode(data));
    } catch (_) {}
  }
}

