import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:dart_model_crafter/model_crafter.dart' as json_to_model;

void main(List<String> arguments) {
  // Inisialisasi pen warna
  final yellowPen = AnsiPen()..yellow();
  final greenPen = AnsiPen()..green();
  final redPen = AnsiPen()..red();
  final bluePen = AnsiPen()..blue();

  // Header
  print(yellowPen('=========================================='));
  print(yellowPen('||                                      ||'));
  print(yellowPen('||        🚀 Dart Model Crafer 🚀       ||'));
  print(yellowPen('||   Effortless Dart Model Generation!  ||'));
  print(yellowPen('||                                      ||'));
  print(yellowPen('=========================================='));

  // Pesan selamat datang
  print(bluePen('\nSilakan pilih opsi input di bawah ini:\n'));

  // Pilihan opsi
  print(yellowPen('1. Manual'));
  print(yellowPen('2. Paste JSON\n'));

  // Input dari pengguna
  stdout.write(greenPen('Masukkan pilihan Anda (1/2): '));
  String? inputType = stdin.readLineSync();

  // Proses input
  if (inputType == '1') {
    print(greenPen('\nAnda memilih: Manual\n'));
    json_to_model.generateModelFromManualInput();
  } else if (inputType == '2') {
    print(greenPen('\nAnda memilih: Copy Paste JSON\n'));
    json_to_model.generateModelFromJson();
  } else {
    print(redPen('\n⚠ Opsi tidak valid. Silakan pilih 1 atau 2.\n'));
  }

  // Footer
  print(yellowPen('=========================================='));
  print(yellowPen('||                                      ||'));
  print(yellowPen('||   Terima kasih telah menggunakan!    ||'));
  print(yellowPen('||                                      ||'));
  print(yellowPen('=========================================='));
}