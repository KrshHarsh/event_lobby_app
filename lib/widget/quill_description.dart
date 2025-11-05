// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:dart_quill_delta/dart_quill_delta.dart';

// class QuillDescription extends StatefulWidget {
//   final String deltaJsonOrPlain;
//   const QuillDescription({super.key, required this.deltaJsonOrPlain});

//   @override
//   State<QuillDescription> createState() => _QuillDescriptionState();
// }

// class _QuillDescriptionState extends State<QuillDescription> {
//   late quill.QuillController _controller;
//   bool expanded = false;

//   @override
//   void initState() {
//     super.initState();
//     try {
//       final content = widget.deltaJsonOrPlain.trim();
//       if (content.startsWith('{') || content.startsWith('[')) {
//         final decoded = jsonDecode(content);
//         final delta = Delta.fromJson(decoded);
//         _controller = quill.QuillController(
//           document: quill.Document.fromDelta(delta),
//           selection: const TextSelection.collapsed(offset: 0),
//         );
//       } else {
//         _controller = quill.QuillController(
//           document: quill.Document()..insert(0, widget.deltaJsonOrPlain),
//           selection: const TextSelection.collapsed(offset: 0),
//         );
//       }
//     } catch (_) {
//       _controller = quill.QuillController(
//         document: quill.Document()..insert(0, widget.deltaJsonOrPlain),
//         selection: const TextSelection.collapsed(offset: 0),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//     final plain = _controller.document.toPlainText();
//     final preview = plain.length > 300 && !expanded ? '${plain.substring(0, 300)}...' : plain;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: isDark ? Colors.grey[900] : Colors.grey[50],
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeInOut,
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AnimatedCrossFade(
//               duration: const Duration(milliseconds: 250),
//               crossFadeState:
//                   expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//               firstChild: Text(
//                 preview,
//                 style: TextStyle(
//                   fontSize: 15.5,
//                   height: 1.6,
//                   color: isDark ? Colors.grey[300] : Colors.grey[900],
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               secondChild: Text(
//                 plain,
//                 style: TextStyle(
//                   fontSize: 15.5,
//                   height: 1.6,
//                   color: isDark ? Colors.grey[300] : Colors.grey[900],
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             if (plain.length > 300)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton.icon(
//                     style: TextButton.styleFrom(
//                       foregroundColor: theme.colorScheme.primary,
//                       backgroundColor: theme.colorScheme.primary.withOpacity(0.07),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     ),
//                     onPressed: () => setState(() => expanded = !expanded),
//                     icon: Icon(
//                       expanded
//                           ? Icons.keyboard_arrow_up_rounded
//                           : Icons.keyboard_arrow_down_rounded,
//                       size: 18,
//                     ),
//                     label: Text(
//                       expanded ? 'Show less' : 'Read more',
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
