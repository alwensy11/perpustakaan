import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookInsertPage extends StatefulWidget {
  @override
  _BookInsertPageState createState() => _BookInsertPageState();
}

class _BookInsertPageState extends State<BookInsertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Method to insert book data to Supabase
  Future<void> insertBook() async {
    final String judul = _judulController.text;
    final String penulis = _penulisController.text;
    final String deskripsi = _deskripsiController.text;

    // Validate input
    if (judul.isEmpty || penulis.isEmpty || deskripsi.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.from('buku').insert([
        {
          'judul': judul,
          'penulis': penulis,
          'deskripsi': deskripsi,
        }
      ]);

      // Check for errors in the response
      if (response.error == null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book added successfully')),
        );

        // Clear the form
        _judulController.clear();
        _penulisController.clear();
        _deskripsiController.clear();

        // Navigate back to the BookListPage and refresh the list
        Navigator.pop(context, true); // Passing true to indicate the data has been added
      } else {
        // Show error message if there's an issue with the insert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error?.message}')),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
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
                  if (value!.isEmpty) {
                    return 'Masukkan Judul Buku';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _penulisController,
                decoration: InputDecoration(labelText: 'Penulis'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Penulis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value!.isEmpty) {
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
                    insertBook();
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
