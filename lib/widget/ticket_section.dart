import 'package:event_lobby_app/core/models/event_model.dart';
import 'package:flutter/material.dart';


class TicketSection extends StatefulWidget {
  final List<TicketModel> tickets;
  final void Function(String ticketId, int qty) onBook;
  const TicketSection({super.key, required this.tickets, required this.onBook});

  @override
  State<TicketSection> createState() => _TicketSectionState();
}

class _TicketSectionState extends State<TicketSection> {
  final Map<String, int> qty = {};
  @override
  void initState() {
    super.initState();
    for (var t in widget.tickets) qty[t.id] = 0;
  }

  void change(String id, int delta, int max) {
    setState(() {
      final cur = qty[id] ?? 0;
      qty[id] = (cur + delta).clamp(0, max);
    });
  }

  double get total {
    double sum = 0;
    for (var t in widget.tickets) {
      sum += (qty[t.id] ?? 0) * t.price;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tickets.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('No tickets available.'));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Tickets & Pricing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ...widget.tickets.map((t) {
        final sold = t.total - t.available;
        final progress = t.total == 0 ? 0.0 : sold / t.total;
        String activity = 'LOW';
        if (progress > 0.6) activity = 'HIGH';
        else if (progress > 0.3) activity = 'MEDIUM';
        final curQty = qty[t.id] ?? 0;
        return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Text(activity))]),
          const SizedBox(height: 6),
          Text(t.description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(children: [Text('₹${t.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(width: 8), if (t.originalPrice > t.price) Text('₹${t.originalPrice.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey))]),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress, minHeight: 6),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [IconButton(onPressed: () => change(t.id, -1, t.available), icon: const Icon(Icons.remove_circle_outline)), SizedBox(width: 40, child: Center(child: Text('$curQty'))), IconButton(onPressed: () => change(t.id, 1, t.available), icon: const Icon(Icons.add_circle_outline))]),
            ElevatedButton(onPressed: curQty > 0 ? () => widget.onBook(t.id, curQty) : null, child: const Text('Add to cart')),
          ])
        ])));
      }).toList(),
      Padding(padding: const EdgeInsets.only(left: 16,  right:16 ,top:  12, bottom: 100), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total: ₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), ElevatedButton(onPressed: total > 0 ? () {} : null, child: const Text('Checkout'))]))
    ]);
  }
}
