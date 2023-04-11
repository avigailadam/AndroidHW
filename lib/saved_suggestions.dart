import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me_208459446/saved_suggestions_notifier.dart';
import 'package:provider/provider.dart';

class SavedSuggestions extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18);

  Future<bool> _handleDismiss(BuildContext context, String name) async {
    final bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Suggestion'),
            content: Text(
                'Are you sure you want to delete $name'
                    ' from saved suggestions?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              )
            ],
          );
        }
    );
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final savedList = context.read<SavedSuggestionsNotifier>().saved.toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView.builder(
            itemCount: savedList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                background: Container(
                  color: Colors.deepPurple,
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.delete),
                      Text(' Delete suggestion')
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.deepPurple,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: const <Widget>[
                      Text('Delete suggestion  '),
                      Icon(Icons.delete)
                    ],
                  ),
                ),
                confirmDismiss: (DismissDirection d) async {
                  return await _handleDismiss(context, savedList[index].asPascalCase);
                },
                onDismissed: (DismissDirection d) {
                  context.read<SavedSuggestionsNotifier>().remove(savedList[index]);
                },
                key: ValueKey(savedList[index]),
                child: ListTile(
                  title: Text(
                    savedList[index].asPascalCase,
                    style: _biggerFont,
                  ),
                ),
              );
            }));
  }
}
