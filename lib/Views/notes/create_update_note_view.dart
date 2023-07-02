import 'package:flutter/widgets.dart';
import 'package:noting/services/auth/auth_service.dart';
import 'package:noting/services/cloud/cloud_note.dart';
import 'package:noting/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _setupTextControlListener()
  {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);

  }

  void _textControllerListener() async {
    if (_note == null) {
      return;
    }
    final note = _note;
    final text = _textController.text;

    await _notesService.updateNote(documentId: note!.documentId, newContent: text);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.content;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.userId;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);

    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        newContent: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
