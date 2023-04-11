import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

enum Status { unauthenticated, authenticated, error, authenticating }

class AuthNotifier extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var _status = Status.unauthenticated;

  User? get currentUser => _status == Status.authenticated? _auth.currentUser : null;
  Status get status => _status;

  Future<bool> signUp(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _status = Status.authenticated;
      return true;
    } catch (e) {
      developer.log('***error signing up: ${e.toString()} ***');
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = Status.authenticated;
      return true;
    } catch (e) {
      developer.log('***error signing in: ${e.toString()} ***');
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
    _status = Status.unauthenticated;
    notifyListeners();
  }
}