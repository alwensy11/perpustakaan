import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oztrmohdnymfpawdygrw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96dHJtb2hkbnltZnBhd2R5Z3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTM4NDcsImV4cCI6MjA0NzEyOTg0N30.ocyqiAlvLQibeoR1axYUeEMfVIPjaeVabrFMuYpY9OI');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Perpustakaan',
      home: BookListPage(),
        debugShowCheckedModeBanner: false,
    );
  }
}
