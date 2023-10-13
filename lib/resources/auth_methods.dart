import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final imageUrl =
            StorageMethods().uploadImageToStorage('profilePics', file!, false);
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'follwers': [],
          'following': [],
          'imageUrl': imageUrl,
        });
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
}
