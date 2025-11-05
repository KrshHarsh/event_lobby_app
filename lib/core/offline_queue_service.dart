import 'package:hive/hive.dart';

class OfflineQueueService {
  final Box _box = Hive.box('offline_queue');

  Future<void> enqueue(Map<String, dynamic> req) async {
    final list = List<Map>.from(_box.get('queue', defaultValue: []) as List);
    list.add(req);
    await _box.put('queue', list);
  }

  List<Map<String, dynamic>> getQueue() {
    final list = _box.get('queue', defaultValue: []) as List;
    return List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e)));
  }

  Future<void> clearQueue() async {
    await _box.put('queue', []);
  }
}
