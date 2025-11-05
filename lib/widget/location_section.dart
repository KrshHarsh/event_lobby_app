import 'package:event_lobby_app/core/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class LocationSection extends StatelessWidget {
  final LocationModel? location;
  const LocationSection({super.key, required this.location});

  Future<void> _openMaps(LocationModel loc) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${loc.lat},${loc.lng}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (location == null) return const SizedBox.shrink();
    final loc = location!;
    final staticUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=${loc.lat},${loc.lng}&zoom=15&size=600x300&markers=color:red%7C${loc.lat},${loc.lng}&key=YOUR_GOOGLE_MAPS_API_KEY';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 180, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(staticUrl), fit: BoxFit.cover))),
      ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16), leading: const Icon(Icons.location_on_outlined, color: Colors.red), title: Text(loc.address), trailing: ElevatedButton.icon(onPressed: () => _openMaps(loc), icon: const Icon(Icons.directions), label: const Text('Get Directions'))),
    ]);
  }
}
