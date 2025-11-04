import 'package:flutter/material.dart';
import 'features/event_detail/event_detail_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Lobby App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomeShell(),
      routes: {
        EventDetailScreen.routeName: (ctx) => const EventDetailScreen(),
      },
    );
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});
  @override
  Widget build(BuildContext context) {
    // Simple home for quick testing navigation to event detail
    return Scaffold(
      appBar: AppBar(title: const Text('Events Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // For now we navigate with a placeholder id
            Navigator.of(context).pushNamed(EventDetailScreen.routeName, arguments: '68f8a30eb97ed4117b44d12b');
          },
          child: const Text('Open sample event'),
        ),
      ),
    );
  }
}
