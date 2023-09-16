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
        ref.watch(firebaseDocumentsProvider).firestoreDocumentsQuery(user!.uid);
    return Column(
      children: [
        const SizedBox(
          height: 65.0,
        ),
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: fileBytes == null
              ? ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result == null) return;

                    setState(() {
                      file = File(result.files.first.name);
                      fileBytes = result.files.first.bytes;
                    });

                    // await ref.read()
                  },
                  child: const Text('Select Document'),
                )
              : Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          file!.path,
                        ),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Cancel Upload',
                              onPressed: () {
                                setState(() {
                                  file = null;
                                  fileBytes = null;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Upload Document',
                              onPressed: () async {
                                await ref
                                    .read(firebaseDocumentsProvider)
                                    .uploadDocument(
                                      documentPath: file!.path,
                                      documentName: file!.path,
                                      description: file!.path,
                                      currentUser: user,
                                      fileBytes: fileBytes!,
                                    );
                                setState(() {
                                  file = null;
                                  fileBytes = null;
                                });
                              },
                              icon: const Icon(
                                Icons.upload_file,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 65.0,
        ),
        Expanded(
          child: FirestoreQueryBuilder<Document>(
            query: documentsQuery,
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Text('Loading Files...');
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
                        color: index % 2 == 0
                            ? Theme.of(context).primaryColorLight
                            : Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22.0,
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
