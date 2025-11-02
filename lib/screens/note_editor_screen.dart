// lib/screens/note_editor_screen.dart
import 'package:flutter/material.dart';
import '../models/note.dart'; // Import the Note model

class NoteEditorScreen extends StatefulWidget {
  // The 'note' object is nullable (optional, ? işareti).
  // If 'note' is null, we are in 'Create New Note' mode.
  // If 'note' is not null, we are in 'Edit Note' mode.
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  // We need 'Controllers' to manage the text inside the TextFields
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    // This method is called ONCE when the screen is first built.
    super.initState();

    // Initialize the text controllers
    // If we are editing an existing note (widget.note != null),
    // fill the controllers with the note's data.
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed (closed)
    // This prevents memory leaks.
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set the title dynamically based on the mode (new vs. edit)
        title: Text(widget.note == null ? 'Yeni Not' : 'Notu Düzenle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO (Step 3): Implement save logic here.
              // final title = _titleController.text;
              // final content = _contentController.text;

              // After saving, go back to the previous screen
              Navigator.pop(context);
            },
          ),
          // Only show delete button if we are editing an existing note
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO (Step 3): Implement delete logic here.

                // After deleting, go back
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController, // Connect the controller
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded( // Takes up all remaining vertical space
              child: TextField(
                controller: _contentController, // Connect the controller
                maxLines: null, // Allows for unlimited lines
                expands: true, // Required for the TextField to expand
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Keeps label at the top
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
