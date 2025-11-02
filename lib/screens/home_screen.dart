// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/note_card.dart';
import '../widgets/folder_card.dart';
import '../models/note.dart';
import '../models/folder.dart';

// --- IMPORT THE NEW SCREENS ---
// We import the screens we just created to navigate to them.
import 'folder_detail_screen.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- SAMPLE DATA (DUMMY DATA) ---
  // This is temporary data to make the UI look complete.
  // We will replace this in Step 3 (State Management).
  List<Folder> folders = [
    Folder(
      id: '1',
      name: 'İş Notları',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      notes: [
        Note(
          id: '1',
          title: 'Toplantı Notları',
          content: 'Bugünkü toplantıda konuşulan önemli konular...',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          folderId: '1',
        ),
      ],
    ),
    Folder(
      id: '2',
      name: 'Projeler',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      notes: [
        Note(
          id: '2',
          title: 'Flutter Proje',
          content: 'Not uygulaması geliştirme süreci...',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          folderId: '2',
        ),
      ],
    ),
  ];

  List<Note> standaloneNotes = [
    Note(
      id: '4',
      title: 'Alışveriş Listesi',
      content: 'Marketten alınacaklar: Süt, ekmek, yumurta...',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // --- DIALOG METHODS ---

  // This method shows a pop-up dialog to add a new note
  void _showAddNoteDialog() {
    showDialog(
      context: context, // 'context' is needed to know where to show the dialog
      builder: (context) => AlertDialog(
        title: const Text('Yeni Not'),
        content: const Column(
          mainAxisSize: MainAxisSize.min, // Makes the dialog size fit its content
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // A small space between the fields
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'İçerik',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Closes the dialog
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              // TODO (Step 3): Add logic here to actually save the note
              Navigator.pop(context); // Closes the dialog
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // This method shows a pop-up dialog to add a new folder
  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Klasör'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Klasör Adı',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Closes the dialog
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              // TODO (Step 3): Add logic here to actually save the folder
              Navigator.pop(context); // Closes the dialog
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

  // --- BUILD METHOD ---
  // This method runs every time the state changes and builds the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notlarım',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to SearchScreen
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show settings menu
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        // Adds "pull-to-refresh" functionality
        onRefresh: () async {
          // TODO (Step 3): Replace this with logic to reload data from database
          await Future.delayed(const Duration(seconds: 1));
        },
        // CustomScrollView allows mixing lists, grids, and other widgets
        // in a single scrollable area.
        child: CustomScrollView(
          slivers: [
            // --- FOLDERS SECTION (GRID) ---
            if (folders.isNotEmpty) ...[
              // This is the "Klasörler" title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Klasörler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // This is the 2-column grid of folders
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,    // 2 columns
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      // Get the specific folder for this grid item
                      final folder = folders[index];

                      // We wrap the card in a GestureDetector to make it tappable
                      return GestureDetector(
                        onTap: () {
                          // --- NAVIGATION LOGIC ---
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // Navigate to FolderDetailScreen and pass the 'folder' object
                              builder: (context) => FolderDetailScreen(folder: folder),
                            ),
                          );
                        },
                        child: FolderCard(folder: folder),
                      );
                    },
                    childCount: folders.length,
                  ),
                ),
              ),
            ],

            // --- NOTES SECTION (LIST) ---
            if (standaloneNotes.isNotEmpty) ...[
              // This is the "Diğer Notlar" or "Notlar" title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    folders.isNotEmpty ? 'Diğer Notlar' : 'Notlar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // This is the vertical list of standalone notes
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      // Get the specific note for this list item
                      final note = standaloneNotes[index];

                      // We wrap the card in a GestureDetector to make it tappable
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            // --- NAVIGATION LOGIC ---
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Navigate to NoteEditorScreen and pass the 'note' object
                                builder: (context) => NoteEditorScreen(note: note),
                              ),
                            );
                          },
                          child: NoteCard(note: note),
                        ),
                      );
                    },
                    childCount: standaloneNotes.length,
                  ),
                ),
              ),
            ],

            // --- EMPTY STATE SECTION ---
            // This widget only shows if both lists are empty
            if (folders.isEmpty && standaloneNotes.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Henüz not yok',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'İlk notunuzu oluşturmak için + butonuna basın',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        // Pass the dialog-showing functions to the FAB
        onNotePressed: _showAddNoteDialog,
        onFolderPressed: _showAddFolderDialog,
      ),
    );
  }
}