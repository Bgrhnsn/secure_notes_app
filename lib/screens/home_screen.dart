import 'package:flutter/material.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/note_card.dart';
import '../widgets/folder_card.dart';
import '../models/note.dart';
import '../models/folder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data for demo
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
        Note(
          id: '3',
          title: 'Backend API',
          content: 'API endpoints ve veri yapıları...',
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
    Note(
      id: '5',
      title: 'Kitap Önerileri',
      content: 'Okumak istediğim kitaplar: Clean Code, Flutter in Action...',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Not'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

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
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

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
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Menu functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh functionality
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            if (folders.isNotEmpty) ...[
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => FolderCard(folder: folders[index]),
                    childCount: folders.length,
                  ),
                ),
              ),
            ],
            if (standaloneNotes.isNotEmpty) ...[
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
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoteCard(note: standaloneNotes[index]),
                    ),
                    childCount: standaloneNotes.length,
                  ),
                ),
              ),
            ],
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
        onNotePressed: _showAddNoteDialog,
        onFolderPressed: _showAddFolderDialog,
      ),
    );
  }
}