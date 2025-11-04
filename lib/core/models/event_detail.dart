class EventDetail {
  final String id;
  final String title;
  final List<String> images;
  final Map<String, dynamic> descriptionDelta;
  final DateTime? startTime;
  final DateTime? endTime;
  final Venue? venue;
  final Participants? participants;
  final List<Ticket> tickets;
  final House? house;

  EventDetail({
    required this.id,
    required this.title,
    required this.images,
    required this.descriptionDelta,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.participants,
    required this.tickets,
    required this.house,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    // Defensive null-safe parsing
    final venue = json['venue'] != null
        ? Venue.fromJson(json['venue'] as Map<String, dynamic>)
        : null;

    final participants = json['participants'] != null
        ? Participants.fromJson(json['participants'] as Map<String, dynamic>)
        : null;

    final tickets = (json['tickets'] as List? ?? [])
        .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
        .toList();

    final house = json['house'] != null
        ? House.fromJson(json['house'] as Map<String, dynamic>)
        : null;

    final images = <String>[];
    if (json['images'] is List) {
      for (var i in json['images']) {
        if (i is Map && i['url'] != null) images.add(i['url']);
      }
    }

    return EventDetail(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      images: images,
      descriptionDelta: (json['description_delta'] ?? {'ops': []}) as Map<String, dynamic>,
      startTime: DateTime.tryParse(json['start_date'] ?? ''),
      endTime: DateTime.tryParse(json['end_date'] ?? ''),
      venue: venue,
      participants: participants,
      tickets: tickets,
      house: house,
    );
  }
}

class Venue {
  final String? address;
  final double? lat;
  final double? lng;

  Venue({this.address, this.lat, this.lng});

  factory Venue.fromJson(Map<String, dynamic> j) => Venue(
        address: j['address'],
        lat: (j['lat'] as num?)?.toDouble(),
        lng: (j['lng'] as num?)?.toDouble(),
      );
}

class Participants {
  final int joined;
  final int capacity;
  Participants({required this.joined, required this.capacity});
  factory Participants.fromJson(Map<String, dynamic> j) => Participants(
        joined: j['joined'] ?? 0,
        capacity: j['capacity'] ?? 0,
      );
}

class Ticket {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int remaining;
  final int total;

  Ticket({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.remaining,
    required this.total,
  });

  factory Ticket.fromJson(Map<String, dynamic> j) => Ticket(
        id: j['id']?.toString() ?? '',
        name: j['name'] ?? '',
        description: j['description'] ?? '',
        price: (j['price'] ?? 0).toDouble(),
        originalPrice: (j['original_price'] ?? j['price'] ?? 0).toDouble(),
        remaining: j['remaining'] ?? 0,
        total: j['available'] ?? 0,
      );
}

class House {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  House({required this.id, required this.name, this.description, this.imageUrl});

  factory House.fromJson(Map<String, dynamic> j) => House(
        id: j['id']?.toString() ?? '',
        name: j['name'] ?? '',
        description: j['description'],
        imageUrl: j['image']?['url'],
      );
}
