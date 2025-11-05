import 'dart:convert';
import 'package:event_lobby_app/core/models/event_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final eventProvider = FutureProvider<EventDetail>((ref) async {
  // Mock API JSON (replace with real API later)
  final mockJson = jsonEncode({
    "id": "1",
    "title": "TechFest 2025",
    "images": [
      "https://picsum.photos/800/400?1",
      "https://picsum.photos/800/400?2",
      "https://picsum.photos/800/400?3"
    ],
    "category": "Technology",
    "subCategory": "Conference",
    "joined": 120,
    "capacity": 250,
    "status": "Filling Fast",
    "views": 890,
    "dateTime": DateTime.now().add(Duration(days: 5)).toIso8601String(),
    "location": "Jaipur Convention Center",
    "description":
        "TechFest 2025 brings together innovators, creators, and developers. Explore AI, Flutter, and the future of digital experiences!",
    "tickets": [
      {
        "name": "Regular Pass",
        "description": "Access to all talks",
        "currentPrice": 499,
        "originalPrice": 699,
        "remaining": 200,
        "total": 250
      },
      {
        "name": "VIP Pass",
        "description": "Front row + Lounge Access",
        "currentPrice": 999,
        "originalPrice": 1299,
        "remaining": 50,
        "total": 50
      }
    ]
  });

  await Future.delayed(const Duration(seconds: 1)); // simulate network delay
  final data = jsonDecode(mockJson);
  return EventDetail.fromJson(data);
});
