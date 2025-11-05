// lib/providers/event_notifier.dart
import 'dart:async';
import 'package:flutter_quill/quill_delta.dart' as flutter_quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_lobby_app/core/models/event_model.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/mock_api.dart';
import '../core/cache_service.dart';
import '../core/offline_queue_service.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

// ------------------- Providers ---------------------
final mockApiProvider = Provider((ref) => const MockApi());
final cacheServiceProvider = Provider((ref) => CacheService());
final offlineServiceProvider = Provider((ref) => OfflineQueueService());

// ------------------- STATE ---------------------
class EventState {
  final bool loading;
  final EventModel? event;
  final Object? error;
  final int viewersNow;

  EventState({
    this.loading = false,
    this.event,
    this.error,
    this.viewersNow = 0,
  });

  EventState copyWith({
    bool? loading,
    EventModel? event,
    Object? error,
    int? viewersNow,
  }) {
    return EventState(
      loading: loading ?? this.loading,
      event: event ?? this.event,
      error: error ?? this.error,
      viewersNow: viewersNow ?? this.viewersNow,
    );
  }
}

// ------------------- NOTIFIER ---------------------
class EventNotifier extends StateNotifier<EventState> {
  final Ref ref;
  Timer? _pollTimer;

  EventNotifier(this.ref) : super(EventState(loading: true));

  /// Load event details (mocked if API fails)
  Future<void> load(String eventId, {bool force = false}) async {
    state = state.copyWith(loading: true);

    final cache = ref.read(cacheServiceProvider);
    final cached = cache.getEventJson(eventId);

    if (cached != null && !force) {
      final model = EventModel.fromJson(cached);
      state = state.copyWith(loading: false, event: model);
    }

    try {
      final api = ref.read(mockApiProvider);
      final json = await api.fetchEventDetail(eventId);

      if (json.isEmpty) {
        final mockJson = _mockEventJson();
        await cache.saveEventJson(eventId, mockJson);
        state = state.copyWith(
          loading: false,
          event: EventModel.fromJson(mockJson),
          error: null,
        );
      } else {
        await cache.saveEventJson(eventId, json);
        state = state.copyWith(
          loading: false,
          event: EventModel.fromJson(json),
          error: null,
        );
      }

      _startPollSim();
    } catch (e) {
      if (state.event == null) {
        final mockJson = _mockEventJson();
        state = state.copyWith(
          loading: false,
          event: EventModel.fromJson(mockJson),
          error: e,
        );
      } else {
        state = state.copyWith(loading: false, error: e);
      }
    }
  }

  /// Simulate "X people viewing now"
  void _startPollSim() {
    _pollTimer?.cancel();
    int v = 4;
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (t) {
      v = (v + (DateTime.now().second % 5)) % 80;
      state = state.copyWith(viewersNow: v);
    });
  }

  Future<void> saveEvent(String id, Map<String, dynamic> json) async {
    final cache = ref.read(cacheServiceProvider);
    await cache.saveSavedEvent(id, json);
  }

  Future<void> bookOffline(Map<String, dynamic> req) async {
    final offline = ref.read(offlineServiceProvider);
    await offline.enqueue(req);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Mock Event Data (descriptionDelta uses flutter_quill.Delta().toJson())
  Map<String, dynamic> _mockEventJson() {
    final flutter_quill.Delta d = flutter_quill.Delta()
      ..insert("Welcome to our exclusive AI networking meetup!\n")
      ..insert("Meet experts, startups, and enthusiasts working on AI, Flutter, and community building.\n")
      ..insert("Expect meaningful discussions, collaboration, and growth.\n");

    return {
      "lobby": {
        "id": "mock_123",
        "title": "AI & Community Networking Meetup",
        "category": "Technology",
        "subCategory": "Networking",
        "participants": {"joined": 45, "capacity": 250},
        "status": "Filling Fast",
        "images": [
          "https://picsum.photos/800/400?1",
          "https://picsum.photos/800/400?2",
          "https://picsum.photos/800/400?3",
          "https://picsum.photos/800/400?4",
          "https://picsum.photos/800/400?5",
          "https://picsum.photos/800/400?6"
        ],
        "start_date": DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        "description_delta": d.toJson(),
        "tickets": [
          {
            "id": "t1",
            "name": "Early Bird",
            "description": "Discounted for early registrants.",
            "price": 299.0,
            "original_price": 499.0,
            "available": 100,
            "total": 250,
            "activityLevel": "MEDIUM"
          },
          {
            "id": "t2",
            "name": "Regular Pass",
            "description": "Standard access to all sessions.",
            "price": 499.0,
            "original_price": 499.0,
            "available": 141,
            "total": 250,
            "activityLevel": "HIGH"
          }
        ],
        "insights": {
          "avg_age": 28,
          "gender_ratio": {"M": 70, "F": 30},
          "top_interests": ["AI", "Flutter", "Startups", "Networking"]
        },
        "host": {
          "id": "h1",
          "name": "Tech House India",
          "description": "A growing tech community hosting learning and networking events across India.",
          "image": "https://picsum.photos/200",
          "admins": [
            {"name": "Krsh", "image": "https://picsum.photos/100"},
            {"name": "Ananya", "image": "https://picsum.photos/101"}
          ]
        }
      }
    };
  }
}

// ------------------- PROVIDER ---------------------
final eventNotifierProvider = StateNotifierProvider.family<EventNotifier, EventState, String>(
  (ref, id) {
    final notifier = EventNotifier(ref);
    notifier.load(id);
    ref.onDispose(() => notifier.dispose());
    return notifier;
  },
);
