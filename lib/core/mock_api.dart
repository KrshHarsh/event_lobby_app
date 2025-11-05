import 'dart:convert';
import 'package:flutter/services.dart';

class MockApi {
  const MockApi();
  Future<Map<String, dynamic>> fetchEventDetail(String eventId) async {
    final raw = await rootBundle.loadString('assets/mock/event_detail.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map;
  }
}
