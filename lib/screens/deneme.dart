import 'package:flutter/material.dart';
// Kendi oluşturduğumuz özel widget'ları (arayüz parçaları) import ediyoruz
import '../widgets/expandable_fab.dart'; // Açılır-kapanır FAB (Floating Action Button)
import '../widgets/note_card.dart';       // Tek bir notu listeleyen kart widget'ı
import '../widgets/folder_card.dart';     // Tek bir klasörü listeleyen kart widget'ı
// Veri modellerimizi (sınıflarımızı) import ediyoruz
import '../models/note.dart';         // Note sınıfının tanımı
import '../models/folder.dart';      // Folder sınıfının tanımı

// HomeScreen, state (durum) tutabilen bir widget olmalı (StatefulWidget)
// Çünkü not listesi ve klasör listesi uygulama çalışırken değişecek (ekleme, silme vb.)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // StatefulWidget'ın state (durum) nesnesini oluşturur
  State<HomeScreen> createState() => _HomeScreenState();
}

// Bu sınıf, HomeScreen widget'ının "durumunu" (içindeki değişkenleri) tutar
class _HomeScreenState extends State<HomeScreen> {
  // --- ÖRNEK VERİ (SAMPLE DATA) ---
  // Bu listeler, veritabanı (Adım 4) hazır olana kadar
  // arayüzün nasıl görüneceğini test etmek için kullanılır.
  // Bunlar "sahte" verilerdir.

  // Sahte klasör listesi
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

  // Sahte bağımsız (klasörsüz) not listesi
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

  // --- METOTLAR (FONKSİYONLAR) ---

  // "Yeni Not Ekle" dialog penceresini (popup) gösteren metot
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog( // AlertDialog, ekranın ortasında çıkan bir penceredir
        title: const Text('Yeni Not'),
        content: Column( // İçerikleri (iki TextField) alt alta dizmek için Column
          mainAxisSize: MainAxisSize.min, // Pencerenin boyutu, içeriği kadar olsun (küçült)
          children: [
            // Başlık için metin giriş alanı
            const TextField(
              decoration: InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // İki TextField arasına boşluk koyar
            // İçerik için metin giriş alanı
            const TextField(
              maxLines: 3, // 3 satırlık bir alan
              decoration: InputDecoration(
                labelText: 'İçerik',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [ // Dialog penceresinin altındaki butonlar
          TextButton(
            onPressed: () => Navigator.pop(context), // Sadece pencereyi kapatır
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Adım 3 ve 4'te (State Management ve Veritabanı)
              // buraya notu *gerçekten* kaydedecek kodlar eklenecek.
              Navigator.pop(context); // Şimdilik sadece pencereyi kapatır
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // "Yeni Klasör Ekle" dialog penceresini (popup) gösteren metot
  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Klasör'),
        content: const TextField( // Klasör adı için tek bir metin giriş alanı
          decoration: InputDecoration(
            labelText: 'Klasör Adı',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Pencereyi kapatır
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Adım 3 ve 4'te buraya klasörü *gerçekten*
              // oluşturacak kodlar eklenecek.
              Navigator.pop(context); // Şimdilik sadece pencereyi kapatır
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

  // --- ARAYÜZ (BUILD METODU) ---
  // Bu metot, Flutter'a ekranın nasıl çizileceğini söyler
  // State (durum) her değiştiğinde bu metot yeniden çalışır
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold, bir ekranın temel iskeletidir (AppBar, body, FAB vb. sağlar)
      appBar: AppBar(
        // AppBar: Ekranın üstündeki başlık çubuğu
        title: const Text(
          'Notlarım',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [ // AppBar'ın sağ tarafındaki ikon butonları
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Arama özelliği buraya eklenecek
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Ayarlar menüsü (örn: sıralama) buraya eklenecek
            },
          ),
        ],
      ),
      // body: Ekranın ana içeriği
      body: RefreshIndicator(
        // Ekranı aşağı çekince yenileme özelliği (pull-to-refresh)
        onRefresh: () async {
          // TODO: Gelecekte burası veritabanından verileri yeniden çekecek
          // Şimdilik 1 saniye bekleyerek yenileme animasyonu gösteriyoruz
          await Future.delayed(const Duration(seconds: 1));
        },
        // CustomScrollView: İçinde birden fazla farklı kaydırılabilir yapıyı
        // (Grid ve List gibi) bir arada tutmamızı sağlayan güçlü bir widget.
        // Normal bir ListView veya GridView ile bunu yapamazdık.
        child: CustomScrollView(
          // slivers: CustomScrollView'in içine konulan kaydırılabilir parçalara "sliver" denir.
          slivers: [
            // --- KLASÖR BÖLÜMÜ (GRID) ---

            // "..." (spread operator): if koşulu doğruysa, bu listenin içindeki
            // widget'ları slivers listesine tek tek ekle.
            if (folders.isNotEmpty) ...[
              // "Klasörler" başlığını ekleyen parça
              const SliverToBoxAdapter( // Normal bir widget'ı (Text) sliver'a dönüştürür
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
              // Klasörlerin ızgara (Grid) yapısını oluşturan parça
              SliverPadding(
                // Grid'in kenarlarına boşluk verir
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  // Grid'in ayarları: 2 sütunlu bir yapı
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,       // Yan yana 2 eleman olacak
                    childAspectRatio: 1.5, // Elemanların en-boy oranı (genişlik/yükseklik)
                    crossAxisSpacing: 12,  // Elemanlar arası yatay boşluk
                    mainAxisSpacing: 12,   // Elemanlar arası dikey boşluk
                  ),
                  // Grid'in içeriğini oluşturan yapı (builder)
                  delegate: SliverChildBuilderDelegate(
                    // Her bir klasör verisi için bir FolderCard widget'ı oluşturur
                        (context, index) => FolderCard(folder: folders[index]),
                    childCount: folders.length, // Klasör sayısı kadar eleman oluştur
                  ),
                ),
              ),
            ],

            // --- NOTLAR BÖLÜMÜ (LIST) ---
            if (standaloneNotes.isNotEmpty) ...[
              // "Diğer Notlar" veya "Notlar" başlığını ekleyen parça
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    // Eğer klasör listesi doluysa "Diğer Notlar", boşsa "Notlar" yaz
                    folders.isNotEmpty ? 'Diğer Notlar' : 'Notlar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Notların dikey listesini oluşturan parça
              SliverPadding(
                // Altta 100px boşluk (FAB'ın üstüne gelmesin diye)
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12), // Notlar arası dikey boşluk
                      // NoteCard widget'ını kullanarak her bir notu çiz
                      child: NoteCard(note: standaloneNotes[index]),
                    ),
                    childCount: standaloneNotes.length, // Not sayısı kadar
                  ),
                ),
              ),
            ],

            // --- BOŞ EKRAN DURUMU (EMPTY STATE) ---
            // Eğer hem klasör hem de not listesi boşsa bu bölümü göster
            // Bu, iyi bir kullanıcı deneyimi (UX) için önemlidir.
            if (folders.isEmpty && standaloneNotes.isEmpty)
            // SliverFillRemaining: Ekranda kalan tüm boşluğu kapla
              const SliverFillRemaining(
                child: Center( // İçeriği (Column) dikey ve yatayda ortala
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
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
      // floatingActionButton: Sağ alttaki "+" butonu
      floatingActionButton: ExpandableFab( // '../widgets/expandable_fab.dart' dosyasından gelen özel widget'ımız
        // Bu FAB içindeki "Not Ekle" butonuna basılınca...
        onNotePressed: _showAddNoteDialog, // ...yukarıda tanımladığımız _showAddNoteDialog metodunu çalıştır
        // Bu FAB içindeki "Klasör Ekle" butonuna basılınca...
        onFolderPressed: _showAddFolderDialog, // ...yukarıda tanımladığımız _showAddFolderDialog metodunu çalıştır
      ),
    );
  }
}