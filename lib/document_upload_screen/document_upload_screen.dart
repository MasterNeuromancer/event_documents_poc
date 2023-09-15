import 'dart:io';

import 'package:event_documents_poc/auth/auth_repository.dart';
import 'package:event_documents_poc/documents/firebase_documents.dart';
import 'package:event_documents_poc/models/document.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  File? file;
  Uint8List? fileBytes;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final documentsQuery =
        ref.watch(firebaseDocumentsProvider).firestoreDocumentsQuery();
    print(file?.path);
    return Column(
      children: [
        const SizedBox(
          height: 65.0,
        ),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result == null) return;

            setState(() {
              file = File(result.files.first.name);
              fileBytes = result.files.first.bytes;
            });

            // await ref.read()
          },
          child: const Text('Select Document'),
        ),
        const SizedBox(
          height: 65.0,
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: InkWell(
              onTap: () async {
                await ref.read(firebaseDocumentsProvider).uploadDocument(
                      documentPath: file!.path,
                      documentName: file!.path,
                      description: file!.path,
                      currentUser: user!,
                      fileBytes: fileBytes!,
                    );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    Text(
                      file!.path,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: FirestoreQueryBuilder<Document>(
            query: documentsQuery,
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              return Padding(
                padding: const EdgeInsets.all(26.0),
                child: ListView.builder(
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    // if we reached the end of the currently obtained items, we try to
                    // obtain more items
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      // Tell FirestoreQueryBuilder to try to obtain more items.
                      // It is safe to call this function from within the build method.
                      snapshot.fetchMore();
                    }

                    final currentDocument = snapshot.docs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.lightBlue : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentDocument.get('documentName') ??
                                      'Video Name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'UserID:   ${currentDocument.get('userID')}',
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.file_present,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
