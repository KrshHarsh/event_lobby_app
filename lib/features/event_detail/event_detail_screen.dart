import 'dart:async';
import 'package:event_lobby_app/core/models/event_model.dart';
import 'package:event_lobby_app/providers/event_notifier.dart';
import 'package:event_lobby_app/widget/community_insights.dart';
import 'package:event_lobby_app/widget/image_carousel.dart';
import 'package:event_lobby_app/widget/location_section.dart';
import 'package:event_lobby_app/widget/quill_description.dart';
import 'package:event_lobby_app/widget/ticket_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, this.eventId = 'mock-event-1'});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  late final notifier = ref.read(eventNotifierProvider(widget.eventId).notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotifierProvider(widget.eventId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Lobby', style: TextStyle(color: Colors.white),), backgroundColor: colorScheme.primary,),
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    final event = state.event!;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar( 
        title: const Text('Event Lobby',style: TextStyle(color: Colors.white)),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.white,)),
          IconButton(
            onPressed: () async {
              final cache = ref.read(cacheServiceProvider);
              await cache.saveSavedEvent(event.id, {
                'savedAt': DateTime.now().toIso8601String(),
                'title': event.title
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event saved locally')),
              );
            },
            icon: const Icon(Icons.bookmark_outline, color: Colors.white,),
          )
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await notifier.load(widget.eventId, force: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ImageCarousel(images: event.images),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildHeader(context, event, state),
                ),
                const SizedBox(height: 12),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: QuillDescription(
                //     deltaJsonOrPlain: event.descriptionDeltaRaw,
                //   ),
                // ),
        
                if (event.host != null)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.host!.image),
                    ),
                    title: Text(
                      event.host!.name,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      event.host!.description,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: const Text('View more events'),
                    ),
                  ),
                CommunityInsights(insights: event.insights),
                TicketSection(
                  tickets: event.tickets,
                  onBook: (ticketId, qty) async {
                    await notifier.bookOffline({
                      'ticketId': ticketId,
                      'qty': qty,
                      'eventId': event.id,
                      'ts': DateTime.now().toIso8601String()
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking queued (offline simulation)'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () {},
        label: Text('${state.viewersNow} viewing now'),
        icon: const Icon(Icons.remove_red_eye),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EventModel event, EventState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final joinedStr = '${event.joined}/${event.capacity} joined';
    final status = event.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(event.category)),
            Chip(label: Text(event.subCategory)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(status, style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              joinedStr,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
           
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '👀 ${event.views} views',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    final localStart = start.toLocal();
    final startStr =
        '${localStart.day}/${localStart.month}/${localStart.year} ${localStart.hour.toString().padLeft(2, '0')}:${localStart.minute.toString().padLeft(2, '0')}';
    if (end == null) return startStr;
    final localEnd = end.toLocal();
    final endStr =
        '${localEnd.day}/${localEnd.month}/${localEnd.year} ${localEnd.hour.toString().padLeft(2, '0')}:${localEnd.minute.toString().padLeft(2, '0')}';
    return '$startStr - $endStr';
  }
}
