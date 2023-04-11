import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { unauthenticated, authenticated, error, authenticating }

class SavedSuggestionsNotifier extends ChangeNotifier {
  final _saved = <WordPair>{};

  Set<WordPair> get saved => _saved;

  void add(WordPair word){
    _saved.add(word);
  }

  void remove(WordPair word){
    _saved.remove(word);
  }
}