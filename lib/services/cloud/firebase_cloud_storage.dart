import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/cloud/cloud_note.dart';
import 'package:noting/services/cloud/cloud_storage_constants.dart';
import 'package:noting/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  Stream<Iterable<CloudNote>> getAllNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            CloudConst.ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map(
                (doc) => CloudNote.fromSnapshot(doc),
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required ownerUserId}) async {
    final document = await notes.add({
      CloudConst.ownerUserIdFieldName: ownerUserId,
      CloudConst.contentFieldName: '',
    });

    final newNote = await document.get();

    return CloudNote(
      documentId: newNote.id,
      ownerUserId: ownerUserId,
      content: '',
    );
  }

  Future<void> updateNote({
    required String documentId,
    required String newContent,
  }) async {
    try {
      await notes
          .doc(documentId)
          .update({CloudConst.contentFieldName: newContent});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteAllNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw UserNotFoundException();
      }

      final notesSnapshot =
          await notes.where('user_id', isEqualTo: user.uid).get();

      if (notesSnapshot.docs.isEmpty) {
        return;
      }

      final batch = FirebaseFirestore.instance.batch();

      for (final noteDoc in notesSnapshot.docs) {
        batch.delete(noteDoc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
