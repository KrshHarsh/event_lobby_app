import 'package:intl/intl.dart';

String formatDateTimeRange(DateTime? start, DateTime? end) {
  if (start == null) return '';
  final df = DateFormat('EEE, d MMM yyyy • hh:mm a');
  if (end == null) return df.format(start);
  if (start.day == end.day) {
    return '${df.format(start)} - ${DateFormat('hh:mm a').format(end)}';
  } else {
    return '${df.format(start)} - ${df.format(end)}';
  }
}

String participantStatus(int joined, int total) =>
    '$joined / $total joined';
