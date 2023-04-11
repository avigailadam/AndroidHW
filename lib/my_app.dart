import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saved_suggestions_notifier.dart';
import 'auth_notifier.dart';
import 'random_words.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => SavedSuggestionsNotifier())
      ],
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const RandomWords(),
      ),
    );
  }
}