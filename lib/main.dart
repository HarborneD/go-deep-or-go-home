import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/services/storage_service.dart';
import 'package:go_deep_or_go_home/ui/screens/guildhall_screen.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/game_event_listener.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storage = await StorageService.init();

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storage)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Deep or Go Home',
      theme: AppTheme.theme,
      navigatorKey: navigatorKey, // Important!
      builder: (context, child) {
        return GameEventListener(navigatorKey: navigatorKey, child: child!);
      },
      home: const GuildhallScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
