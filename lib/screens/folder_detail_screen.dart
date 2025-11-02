// lib/screens/folder_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/folder.dart'; // Import the Folder model (yolun doğru olduğundan emin olun)
import '../models/note.dart';   // Import the Note model
import 'note_editor_screen.dart'; // Import the editor screen for navigation

class FolderDetailScreen extends StatelessWidget {
  // This screen needs to know which folder to display.
  final Folder folder;

  // The constructor requires a 'folder' object to be passed in.
  const FolderDetailScreen({Key? key, required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use the folder's name as the AppBar title
        title: Text(folder.name),
      ),
      body: ListView.builder(
        // For now, just list the dummy notes from inside the folder object
        // (Bu sahte veriyi 'folder' nesnesinden alıyoruz)
        itemCount: folder.notes.length,
        itemBuilder: (context, index) {
          final note = folder.notes[index];
          // TODO: This should be your custom 'NoteCard' widget
          // (Burada kendi NoteCard widget'ınızı kullanabilirsiniz)
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content, maxLines: 1),
            onTap: () {
              // --- NAVIGATION LOGIC ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Pass the selected 'note' to the editor screen
                  builder: (context) => NoteEditorScreen(note: note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- NAVIGATION LOGIC ---
          // Go to the editor screen in 'new note' mode.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(),
              // Adım 3'te buraya folder.id'yi de paslayabiliriz
              // böylece yeni notun hangi klasöre ait olduğunu biliriz.
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}