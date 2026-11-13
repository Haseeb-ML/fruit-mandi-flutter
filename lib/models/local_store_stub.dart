class LocalStore {
  static Map<String, dynamic>? _memory;

  static Future<Map<String, dynamic>?> load() async => _memory;

  static Future<void> save(Map<String, dynamic> data) async {
    _memory = Map<String, dynamic>.from(data);
  }
}

