import 'dart:convert';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

void generateModelFromManualInput() {
  final yellowPen = AnsiPen()..yellow();
  final greenPen = AnsiPen()..green();
  final redPen = AnsiPen()..red();

  print(greenPen('\n=== Input Manual ==='));
  print(yellowPen('Masukkan nama model:'));
  String? modelName = stdin.readLineSync();

  // Validasi nama model
  if (modelName == null || modelName.isEmpty) {
    printError('Nama model tidak boleh kosong.');
    return;
  }

  if (!RegExp(r'[A-Z]').hasMatch(modelName)) {
    printError('Nama model harus mengandung setidaknya satu huruf besar.');
    return;
  }

  print(yellowPen('\nMasukkan field dan tipe data (contoh: name String):'));
  print(redPen('Ketik "selesai" untuk mengakhiri.\n'));

  Map<String, String> fields = {};
  while (true) {
    stdout.write(greenPen('Field dan tipe data: '));
    String? input = stdin.readLineSync();
    if (input == 'selesai') break;
    var parts = input!.split(' ');
    if (parts.length == 2) {
      fields[parts[0]] = parts[1];
    } else {
      printError('Format tidak valid. Gunakan format: fieldName fieldType');
    }
  }

  generateModelFile(modelName, fields);
}

void generateModelFromJson() {
  final yellowPen = AnsiPen()..yellow();

  print(yellowPen('Masukkan JSON:'));
  String? jsonInput = stdin.readLineSync();

  try {
    var jsonMap = jsonDecode(jsonInput!);
    if (jsonMap is Map) {
      print(yellowPen('\nMasukkan nama model:'));
      String? modelName = stdin.readLineSync();

      // Validasi nama model
      if (modelName == null || modelName.isEmpty) {
        printError('Nama model tidak boleh kosong.');
        return;
      }

      if (!RegExp(r'[A-Z]').hasMatch(modelName)) {
        printError('Nama model harus mengandung setidaknya satu huruf besar.');
        return;
      }

      Map<String, String> fields = {};
      jsonMap.forEach((key, value) {
        fields[key] = value.runtimeType.toString();
      });
      generateModelFile(modelName, fields);
    } else {
      printError('Input JSON tidak valid.');
    }
  } catch (e) {
    printError('Error parsing JSON: $e');
  }
}

void generateModelFile(String modelName, Map<String, String> fields) {
  final greenPen = AnsiPen()..green();

  var buffer = StringBuffer();
  buffer.writeln('class $modelName {');
  fields.forEach((key, value) {
    buffer.writeln('  $value $key;');
  });
  buffer.writeln('');
  buffer.writeln('  $modelName({');
  fields.forEach((key, value) {
    buffer.writeln('   required this.$key,');
  });
  buffer.writeln('  });');
  buffer.writeln('');
  buffer.writeln('  factory $modelName.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $modelName(');
  fields.forEach((key, value) {
    buffer.writeln('      $key: json[\'$key\'],');
  });
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln('');
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  fields.forEach((key, value) {
    buffer.writeln('      \'$key\': $key,');
  });
  buffer.writeln('    };');
  buffer.writeln('  }');
  buffer.writeln('}');

  // Penamaan file berdasarkan nama model
  String fileName = modelName.toLowerCase();
  if (modelName == "UserModel") {
    fileName = "user_model";
  }

  var file = File('$fileName.dart');
  file.writeAsStringSync(buffer.toString());
  print(greenPen('\n✅ Model $modelName berhasil dibuat di ${file.path}'));
}

void generateModelFromJsonTest(String jsonInput, String modelName) {
  try {
    var jsonMap = jsonDecode(jsonInput);
    if (jsonMap is Map) {
      Map<String, String> fields = {};
      jsonMap.forEach((key, value) {
        fields[key] = value.runtimeType.toString();
      });
      generateModelFile(modelName, fields);
    } else {
      printError('Input JSON tidak valid.');
    }
  } catch (e) {
    printError('Error parsing JSON: $e');
  }
}

void printError(String message) {
  final redPen = AnsiPen()..red();
    print(redPen('\n❌ $message\n'));
}