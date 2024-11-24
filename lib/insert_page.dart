import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpustakaan/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Method to insert book data to Supabase
  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final judul = _judulController.text;
    final penulis = _penulisController.text;
    final deskripsi = _deskripsiController.text;

    // Validate input
    if (judul.isEmpty || penulis.isEmpty || deskripsi.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua wajib diisi')),
      );
      return;
    }

    final response = await Supabase.instance.client.from('buku').insert([
      {
        'judul': judul,
        'penulis': penulis,
        'deskripsi': deskripsi,
      }
    ]); // Make sure to call .execute() to get the result

    // Check for errors in the response
    if (response != null) {
      // Display the actual error message from Supabase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error: ${response.error!.message}')), // Access error message correctly
      );
    } else {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Buku berhasil ditambahkan')),
      );
    }

    // Clear the form
    _judulController.clear();
    _penulisController.clear();
    _deskripsiController.clear();

    // Navigate back to the BookListPage and refresh the list
    Navigator.pop(
        context, true); // Passing true to indicate the data has been added

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BookListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Judul Buku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Judul Buku';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _penulisController,
                decoration: InputDecoration(labelText: 'Penulis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Penulis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Deskripsi Buku';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Insert the book if the form is valid
                    _addBook();
                  }
                },
                child: Text('Tambah Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
