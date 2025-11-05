class TicketModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final int available;
  final int total;
  TicketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.available,
    required this.total,
  });
  factory TicketModel.fromJson(Map<String, dynamic> j) {
    return TicketModel(
      id: j['id'].toString(),
      name: j['name'] ?? '',
      description: j['description'] ?? '',
      price: (j['price'] ?? j['currentPrice'] ?? 0).toDouble(),
      originalPrice: (j['original_price'] ?? j['originalPrice'] ?? j['price'] ?? 0).toDouble(),
      available: (j['available'] ?? 0) as int,
      total: (j['total'] ?? j['capacity'] ?? 0) as int,
    );
  }
}

class HostModel {
  final String id;
  final String name;
  final String description;
  final String image;
  HostModel({required this.id, required this.name, required this.description, required this.image});
  factory HostModel.fromJson(Map<String, dynamic> j) =>
      HostModel(id: j['id']?.toString() ?? '', name: j['name'] ?? '', description: j['description'] ?? '', image: j['image'] ?? '');
}

class LocationModel {
  final double lat;
  final double lng;
  final String address;
  LocationModel({required this.lat, required this.lng, required this.address});
  factory LocationModel.fromJson(Map<String, dynamic> j) {
    return LocationModel(
      lat: (j['lat'] ?? j['latitude'] ?? 0).toDouble(),
      lng: (j['lng'] ?? j['longitude'] ?? 0).toDouble(),
      address: j['address'] ?? j['name'] ?? '',
    );
  }
}

class EventModel {
  final String id;
  final String title;
  final List<String> images;
  final String category;
  final String subCategory;
  final String status;
  final DateTime start;
  final DateTime? end;
  final LocationModel? venue;
  final String descriptionDeltaRaw;
  final int joined;
  final int capacity;
  final int views;
  final List<TicketModel> tickets;
  final HostModel? host;
  final Map<String, dynamic>? insights;

  EventModel({
    required this.id,
    required this.title,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.status,
    required this.start,
    this.end,
    this.venue,
    required this.descriptionDeltaRaw,
    required this.joined,
    required this.capacity,
    required this.views,
    required this.tickets,
    this.host,
    this.insights,
  });
factory EventModel.fromJson(Map<String, dynamic> j) {
  final lobby = (j['lobby'] ?? j) as Map;

  // Images
  final List<String> images = [];
  if (lobby['images'] is List) {
    for (var it in (lobby['images'] as List)) {
      if (it is String) {
        images.add(it);
      } else if (it is Map && it['url'] != null) {
        images.add(it['url'].toString());
      }
    }
  }

  // Tickets (ensure type safety)
  final List<TicketModel> tickets = [];
  if (lobby['tickets'] is List) {
    for (var t in lobby['tickets']) {
      if (t is Map) tickets.add(TicketModel.fromJson(Map<String, dynamic>.from(t)));
    }
  }

  // Host
  HostModel? host;
  if (lobby['host'] is Map) {
    host = HostModel.fromJson(Map<String, dynamic>.from(lobby['host']));
  }

  // Venue
  LocationModel? venue;
  if (lobby['venue'] is Map) {
    venue = LocationModel.fromJson(Map<String, dynamic>.from(lobby['venue']));
  }

  // Start/end
  DateTime start;
  try {
    start = DateTime.parse(
      lobby['start_date'] ?? lobby['date'] ?? DateTime.now().toIso8601String(),
    );
  } catch (_) {
    start = DateTime.now();
  }

  DateTime? end;
  if (lobby['end_date'] != null) {
    try {
      end = DateTime.parse(lobby['end_date']);
    } catch (_) {
      end = null;
    }
  }

  // Insights (convert dynamic map safely)
  Map<String, dynamic>? insights;
  if (lobby['insights'] is Map) {
    insights = Map<String, dynamic>.from(lobby['insights']);
  }

  // Participants
  final participants = (lobby['participants'] is Map)
      ? Map<String, dynamic>.from(lobby['participants'])
      : <String, dynamic>{};

  return EventModel(
    id: (lobby['id'] ?? 'mock-event').toString(),
    title: lobby['title'] ?? lobby['name'] ?? '',
    images: images,
    category: lobby['category'] ?? '',
    subCategory: lobby['subCategory'] ?? lobby['subcategory'] ?? '',
    status: lobby['status'] ?? 'Open spots',
    start: start,
    end: end,
    venue: venue,
    descriptionDeltaRaw: lobby['description_delta'] != null
        ? lobby['description_delta'].toString()
        : (lobby['description'] ?? ''),
    joined: (participants['joined'] ?? lobby['joined'] ?? 0) as int,
    capacity: (participants['capacity'] ?? lobby['capacity'] ?? 0) as int,
    views: (lobby['views'] ?? 0) as int,
    tickets: tickets,
    host: host,
    insights: insights,
  );
}
}