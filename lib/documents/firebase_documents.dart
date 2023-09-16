import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_documents_poc/firebase/firebase_providers.dart';
import 'package:event_documents_poc/models/document.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseDocuments {
  const FirebaseDocuments(
    this._firebaseFirestore,
    this._firebaseFirestoreStorage,
  );
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseFirestoreStorage;

  Query<Document> firestoreDocumentsQuery(String userID) {
    return _firebaseFirestore
        .collection('Documents')
        .withConverter(
          fromFirestore: Document.fromFirestore,
          toFirestore: (
            Document document,
            _,
          ) =>
              document.toFirestore(),
        )
        .where("userID", isEqualTo: userID);
    // .orderBy('createdDate');
  }

  Future<void> saveDocument(Document documentBeingSent) async {
    try {
      final DocumentReference<Document> documentDocRef = _firebaseFirestore
          .collection('Documents')
          .withConverter(
            fromFirestore: Document.fromFirestore,
            toFirestore: (
              Document document,
              SetOptions? _,
            ) =>
                document.toFirestore(),
          )
          .doc(documentBeingSent.documentName);
      await documentDocRef.set(documentBeingSent);
    } catch (e) {
      print("********error in save Document function: $e");
      // FirebaseCrashlytics.instance.log("ERROR: $e");
      // FirebaseCrashlytics.instance.recordError(
      //   e,
      //   null,
      // );
    }
  }

  Future<void> uploadDocument({
    required String documentPath,
    required String documentName,
    required String description,
    required User currentUser,
    required Uint8List fileBytes,
  }) async {
    try {
      Reference documentRef = _firebaseFirestoreStorage
          .ref()
          .child("Documents")
          .child(documentName);
      await documentRef.putData(fileBytes);
      String documentUrl = await documentRef.getDownloadURL();

      Document uploadDocument = Document(
        documentName: documentName,
        documentUrl: documentUrl,
        userDisplayName: currentUser.displayName,
        userID: currentUser.uid,
        createdDate: DateTime.now(),
        description: description,
      );

      saveDocument(uploadDocument);
    } catch (e) {
      print("********error in upload document funct: $e");
      // FirebaseCrashlytics.instance.log("ERROR: $e");
      // FirebaseCrashlytics.instance.recordError(
      //   e,
      //   null,
      // );
      // rethrow;
    }
  }
}

final Provider<FirebaseDocuments> firebaseDocumentsProvider =
    Provider<FirebaseDocuments>((ref) {
  return FirebaseDocuments(
    ref.read(firebaseFirestoreProvider),
    ref.read(firebaseStorageProvider),
  );
});
