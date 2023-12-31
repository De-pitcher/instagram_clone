import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'storage_methods.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> user() => _auth.authStateChanges();

  Future<model.User> getCurrentUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final imageUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          imageUrl: imageUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invali-email') {
        res = 'The email address is not valid';
      } else if (e.code == 'email-already-in-use') {
        res = 'Another account already exist with the given email address';
      } else if (e.code == 'operation-not-allowed') {
        res = 'Cannot create account';
      } else if (e.code == 'weak-password') {
        res = 'Password is strong enough';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invali-email') {
        res = 'The email address is not valid';
      } else if (e.code == 'email-already-in-use') {
        res = 'Another account already exist with the given email address';
      } else if (e.code == 'operation-not-allowed') {
        res = 'Cannot create account';
      } else if (e.code == 'weak-password') {
        res = 'Password is strong enough';
      }
      res = 'An error occurred';
      return res;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
