import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Hive or other services here later
  runApp(const ProviderScope(child: MyApp()));
}
