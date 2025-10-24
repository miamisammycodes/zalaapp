import 'dart:io';

void main() {
  final directory = Directory('./');
  final dartFiles = directory
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'));

  for (final file in dartFiles) {
    final lines = File(file.path).readAsLinesSync();
    final cleanedLines = <String>[];

    for (var line in lines) {
      // Skip lines containing URLs
      if (line.contains(RegExp('https?://'))) {
        cleanedLines.add(line);
        continue;
      }

      // Remove single-line comments (//)
      line = line.split('//')[0].trimRight();

      // If the line is not empty after comment removal, keep it
      if (line.isNotEmpty) {
        cleanedLines.add(line);
      }
    }

    // Write the cleaned lines back to the file
    File(file.path).writeAsStringSync(cleanedLines.join('\n'));
    print('Processed: ${file.path}');
  }
}
