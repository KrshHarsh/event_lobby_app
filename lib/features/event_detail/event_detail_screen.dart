import 'package:event_lobby_app/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import '../../core/api/aroundu_api.dart';
import '../../core/models/event_detail.dart';

class EventDetailScreen extends StatefulWidget {
  static const routeName = '/event-detail';
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Future<EventDetail> future;

  @override
  void initState() {
    super.initState();
    final api = AroundUApi('<YOUR_TOKEN_HERE>');
    future = api.fetchEventDetail('68f8a30eb97ed4117b44d12b')
        .then((json) => EventDetail.fromJson(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Detail')),
      body: FutureBuilder<EventDetail>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          } else if (snap.hasData) {
            final e = snap.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(e.title, style: Theme.of(context).textTheme.headlineSmall),
                Text(formatDateTimeRange(e.startTime, e.endTime)),
                Text(e.venue?.address ?? 'No address'),
                Text('Images: ${e.images.length}'),
                Text('Tickets: ${e.tickets.length}'),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
