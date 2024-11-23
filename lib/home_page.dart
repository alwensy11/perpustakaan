import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert_page.dart';

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
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Text(
          'Daftar Buku',
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchBooks, // Tombol untuk refresh data
          ),
        ],
        backgroundColor: Colors.brown,
      ),
      body: buku.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: buku.length,
              itemBuilder: (context, index) {
                final book = buku[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(book['judul'] ?? 'No judul',
                        style: GoogleFonts.anuphan(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book['penulis'] ?? 'No penulis',
                            style: GoogleFonts.lato(fontSize: 14)),
                        Text(book['deskripsi'] ?? 'No deskripsi',
                            style: GoogleFonts.sail(fontSize: 12)),
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
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // Navigate to the insert page and await the result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookInsertPage()),
            );

            // If the result is true, refresh the book list
            if (result == true) {
              fetchBooks();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.add, color: Colors.white)],
          ),
        ),
      ),
    );
  }
}
