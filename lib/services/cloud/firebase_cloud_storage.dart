import 'package:cloud_firestore/cloud_firestore.dart';
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
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId:
                      doc.data()[CloudConst.ownerUserIdFieldName] as String,
                  content: doc.data()[CloudConst.contentFieldName] as String,
                );
              }));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNewNote({required ownerUserId}) async {
    await notes.add({
      CloudConst.ownerUserIdFieldName: ownerUserId,
      CloudConst.contentFieldName: '',
    });
  }

  Future<void> updateNote({
    required String documentId,
    required String newContent,
  }) async {
    try{
    await notes.doc(documentId).update({CloudConst.contentFieldName: newContent});
    }
    catch(e)
    {
      throw CouldNotUpdateNoteException();
    }
  }
  Future<void> deleteNote({required String documentId}) async
  {
    try{
     await notes.doc(documentId).delete();
    }
    catch (e)
    {
      throw CouldNotDeleteNoteException();
    }
  }
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
