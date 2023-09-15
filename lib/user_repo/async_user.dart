// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_documents_poc/auth/auth_repository.dart';
import 'package:event_documents_poc/firebase/firebase_providers.dart';
import 'package:event_documents_poc/models/user.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_user.g.dart';

@riverpod
class AsyncUser extends _$AsyncUser {
  Future<User?> _fetchUser() async {
    FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    String? userID = user!.uid;

    final userDocRef = firestore.collection("users").doc(userID).withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );
    final docSnap = await userDocRef.get();
    final currentUser = docSnap.data(); // Convert to City object
    if (currentUser != null) {
      print(currentUser.toString());
    } else {
      print("No such document. $userID");
    }

    return currentUser;
  }

  Future<String?> addUser() async {
    // FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
    print('attempting User in addUser userRepository');
    // final UserCreationFormNotifier user =
    //     _ref.watch(userCreationFormNotifierProvider.notifier);
    // print(user.state.userDisplayName);
    // final User userData = user.state;
    // final String? userID = userData.userId;
    print('customerName in CustomerService');
    // print(userID);

    // final DocumentReference<User> docRef = firestore
    //     .collection('users')
    //     .withConverter(
    //       fromFirestore: User.fromFirestore,
    //       toFirestore: (
    //         User user,
    //         SetOptions? _,
    //       ) =>
    //           user.toFirestore(),
    //     )
    //     .doc(userID);
    // print(docRef.path);
    try {
      print('attempting to save user data to firestore');
      // await docRef.set(userData);
      print('successful');
    } on FirebaseException catch (e) {
      print(e.message);
      return e.message;
    }
    return null;
  }

  // Future<String?> saveUserAvatar(String avatarUrl) async {
  //   print('attempting saveUserAvatar in userRepository');
  //   FirebaseFirestore _firestore = ref.read(firebaseFireStoreProvider);
  //   final user = ref.watch(firebaseAuthRepositoryProvider).currentUser;

  //   String? userID = user!.uid;
  //   final userRef = _firestore.collection("users").doc(userID);

  //   try {
  //     print('attempting to save user avatarUrl to firestore');
  //     // await docRef.set(userData);
  //     await userRef.update({"avatarUrl": avatarUrl}).then(
  //       (value) => {
  //         print("DocumentSnapshot successfully updated!"),
  //         ref.invalidateSelf(),
  //       },
  //       onError: (e) => print("Error updating user avatar document $e"),
  //     );
  //     print('successfully saved avatarUrl to Users collection');
  //   } on FirebaseException catch (e) {
  //     print(e.message);
  //     print("********error: " + e.toString());
  //     FirebaseCrashlytics.instance.log("ERROR: " + e.toString());
  //     FirebaseCrashlytics.instance.recordError(
  //       e,
  //       null,
  //     );
  //     return e.message;
  //   }
  //   return null;
  // }

  @override
  Future<User?> build() async {
    return _fetchUser();
  }
}
