import 'package:flutter/material.dart';

class EventDetail {
  final String id;
  final String title;
  final List<String> images;
  final String category;
  final String subCategory;
  final int joined;
  final int capacity;
  final String status;
  final int views;
  final DateTime dateTime;
  final String location;
  final String description;
  final List<Ticket> tickets;

  EventDetail({
    required this.id,
    required this.title,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.joined,
    required this.capacity,
    required this.status,
    required this.views,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.tickets,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? 'General',
      subCategory: json['subCategory'] ?? 'Community',
      joined: json['joined'] ?? 0,
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'Open',
      views: json['views'] ?? 0,
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'] ?? 'Unknown',
      description: json['description'] ?? '',
      tickets: (json['tickets'] as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
    );
  }
}

class Ticket {
  final String name;
  final String description;
  final double currentPrice;
  final double originalPrice;
  final int remaining;
  final int total;

  Ticket({
    required this.name,
    required this.description,
    required this.currentPrice,
    required this.originalPrice,
    required this.remaining,
    required this.total,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      remaining: json['remaining'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
