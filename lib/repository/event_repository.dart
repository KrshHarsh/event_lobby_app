import 'dart:convert';
import 'package:event_lobby_app/core/models/event_detail.dart';
import 'package:flutter/services.dart';


class EventRepository {
  Future<EventDetail> fetchEventDetail() async {
    final data = await rootBundle.loadString('assets/mock/event_detail.json');
    final json = jsonDecode(data);
    return EventDetail.fromJson(json);
  }
}
