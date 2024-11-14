import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  // Buat variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> buku = [];

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Panggil fungsi fetchBooks() untuk mendapatkan daftar buku
  }

  // Fungsi untuk mengambil data buku dari supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('buku').select();

    setState(() {
      buku = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Buku'),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: fetchBooks // Tombol untuk refresh data
                ),
          ],
        ),
        body: buku.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: buku.length,
                itemBuilder: (context, index) {
                  final book = buku[index];
                  return ListTile(
                    title: Text(book['judul'] ?? 'No judul',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      children: [
                        Text(book['penulis'] ?? 'No penulis',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 14)),
                        Text(book['deskripsi'] ?? 'No deskripsi',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
