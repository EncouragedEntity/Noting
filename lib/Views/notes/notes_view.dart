import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/Views/notes/notes_list_view.dart';
// ignore: unused_import
import 'dart:developer' as devtools show log;

import 'package:noting/constants/routes.dart';
import 'package:noting/services/auth/auth_service.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/services/cloud/firebase_cloud_storage.dart';

import '../../enums/menu_action.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/log_out_dialog.dart';

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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.createUpdate,
              );
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logOut:
                  if (await LogOutDialog().show(context)) {
                    context.read<AuthBloc>().add(const AuthLogOutEvent());
                  }
                  break;
                case MenuAction.deleteAllNotes:
                  {
                    _notesService.deleteAllNotes();
                  }
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.deleteAllNotes,
                  child: Text('Delete all'),
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
            default:
              break;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
