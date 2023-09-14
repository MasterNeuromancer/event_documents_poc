import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._ref);
  final FirebaseAuth _auth;
  final Ref _ref;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      print('email auth failure');
      print(e);
      rethrow;
    }
  }

  Future registerWithEmail(
      String email, String password, String? displayName) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user == null) {
        throw const FormatException('User could not be created');
      }
      _auth.currentUser!.updateDisplayName(displayName);
      // _ref
      //     .read(userCreationFormNotifierProvider.notifier)
      //     .setUserIdUserDisplayNameEmail(
      //       user.uid,
      //       displayName,
      //       email,
      //     );
      // _ref.read(userRepositoryProvider).addUser();
    } catch (e) {
      print('email registration failure');
      print(e.toString());
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider), ref);
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
