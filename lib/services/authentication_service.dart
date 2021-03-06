import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_shopping_list/models/user.dart';
import 'package:flutter_shopping_list/services/database_service.dart';

class AuthenticationService {
  final FirebaseAuth _auth;
  AuthenticationService(this._auth);

  SimpleUser? _userfromFirebaseUser(User? user) {
    return user != null
        ? SimpleUser(
            user.uid,
          )
        : null;
  }

  Stream<SimpleUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userfromFirebaseUser(user));
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await DatabaseService(user.uid).updateFcmTokenOfUser();
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      String? emsg;
      if (e.message != null) emsg = e.message;
      log(emsg!);
      return e.message;
    }
  }

  // sign up and create document for the user containing userId, houseId and name (email)
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await DatabaseService(user.uid).createUserDocumentInDatabase(email);
      await DatabaseService(user.uid).createHouseInDatabase();
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
