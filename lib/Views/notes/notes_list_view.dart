import 'package:flutter/material.dart';
import 'package:noting/constants/notes.dart';
import 'package:noting/services/cloud/cloud_note.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text('Empty here'),
      );
    }
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: ((context, index) {
          final note = notes.elementAt(index);

          return Container(
            decoration: BoxDecoration(
              border: const Border(
                  bottom: BorderSide(width: 1, color: Colors.black)),
              color: Colors.grey.shade200,
            ),
            child: ListTile(
              onTap: () {
                onTap(note);
              },
              title: Text(
                note.content.length > NoteConst.maxTitleLen
                    ? '${note.content.substring(0, NoteConst.maxTitleLen)}...'
                    : note.content,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete ?? false) {
                    onDeleteNote(note);
                  }
                },
              ),
            ),
          );
        }));
  }

  Future<bool?> showDeleteDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
