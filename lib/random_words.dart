import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello_me_208459446/saved_suggestions_notifier.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'auth_notifier.dart';
import 'saved_suggestions.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return SavedSuggestions();
        },
      ),
    );
  }

  void _login() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return LoginScreen();
    }));
  }

  void _logout() async {
    final authRepo = context.read<AuthNotifier>();
    await authRepo.signOut();
    const snackBar = SnackBar(
      content: Text('sign out completed successfully'),
      duration: Duration(seconds: 2),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW from here ...
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
              onPressed:
              context.watch<AuthNotifier>().currentUser == null ? _login : _logout,
              icon: context.watch<AuthNotifier>().currentUser == null
                  ? const Icon(Icons.login)
                  : const Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          var alreadySaved = context.watch<SavedSuggestionsNotifier>().saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              // NEW from here ...
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  context.read<SavedSuggestionsNotifier>().remove(_suggestions[index]);
                } else {
                  context.read<SavedSuggestionsNotifier>().add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }
}