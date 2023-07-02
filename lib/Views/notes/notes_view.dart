import 'package:flutter/material.dart';
import 'package:noting/Views/notes/notes_list_view.dart';
// ignore: unused_import
import 'dart:developer' as devtools show log;

import 'package:noting/constants/routes.dart';
import 'package:noting/services/auth/auth_service.dart';
import 'package:noting/services/cloud/cloud_storage_constants.dart';
import 'package:noting/services/cloud/firebase_cloud_storage.dart';

import '../../enums/menu_action.dart';
import '../../services/cloud/cloud_note.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.userId;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logOut:
                  if (await showLogOutDialog(context)) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                  break;
                case MenuAction.addEditNote:
                  Navigator.of(context).pushNamed(
                    AppRoutes.createUpdate,
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.addEditNote,
                  child: Text('Add note'),
                ),
                PopupMenuItem(
                  value: MenuAction.logOut,
                  child: Text('Log out'),
                ),
              ];
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
        title: const Text('Your notes'),
      ),
      body: StreamBuilder(
        stream: _notesService.getAllNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              break;
            case ConnectionState.active:
              {
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;

                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        AppRoutes.createUpdate,
                        arguments: note,
                      );
                    },
                  );
                }
              }
              break;
            case ConnectionState.none:
              break;
            case ConnectionState.done:
              break;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Log out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out'),
              )
            ],
          );
        }).then((value) => value ?? false);
  }
}
