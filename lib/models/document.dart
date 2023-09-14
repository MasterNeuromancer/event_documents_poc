import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Document {
  final String? documentName;
  final String? documentUrl;
  final String? userDisplayName;
  final String? userID;
  final DateTime? createdDate;
  final String? description;

  const Document({
    this.documentName,
    this.documentUrl,
    this.userDisplayName,
    this.userID,
    this.createdDate,
    this.description,
  });

  @override
  String toString() {
    return 'Document(documentName: $documentName, documentUrl: $documentUrl, userDisplayName: $userDisplayName, userID: $userID, createdDate: $createdDate, description: $description)';
  }

  Document copyWith({
    String? documentName,
    String? documentUrl,
    String? userDisplayName,
    String? userID,
    DateTime? createdDate,
    String? description,
  }) {
    return Document(
      documentName: documentName ?? this.documentName,
      documentUrl: documentUrl ?? this.documentUrl,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userID: userID ?? this.userID,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
    );
  }

  factory Document.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final dynamic data = snapshot.data();
    return Document(
      documentName: data?['documentName'],
      documentUrl: data?['documentUrl'],
      userDisplayName: data?['userDisplayName'],
      userID: data?['userID'],
      createdDate: (data?['createdDate'] as Timestamp).toDate(),
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (documentName != null) 'documentName': documentName,
      if (documentUrl != null) 'documentUrl': documentUrl,
      if (userDisplayName != null) 'userDisplayName': userDisplayName,
      if (userID != null) 'userID': userID,
      if (createdDate != null) 'createdDate': createdDate,
      if (description != null) 'description': description,
    };
  }

  factory Document.empty() => const Document(
        documentName: '',
        documentUrl: '',
        userDisplayName: '',
        userID: '',
        createdDate: null,
        description: '',
      );
}
