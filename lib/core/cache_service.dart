import 'package:hive/hive.dart';

class CacheService {
  final Box _box = Hive.box('saved_events');

  Future<void> saveEventJson(String id, Map<String, dynamic> json) async {
    await _box.put('event:$id', json);
  }

  Map<String, dynamic>? getEventJson(String id) {
    final v = _box.get('event:$id');
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  Future<void> saveSavedEvent(String id, Map<String, dynamic> json) async {
    await _box.put('saved:$id', json);
  }

  bool isEventSaved(String id) => _box.containsKey('saved:$id');

  Future<void> removeSavedEvent(String id) async => await _box.delete('saved:$id');
}
