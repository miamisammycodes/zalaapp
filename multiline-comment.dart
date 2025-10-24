import 'dart:io';

void main() {
  final directory = Directory('./');
  final dartFiles = directory
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'));
  for (final FileSystemEntity file in dartFiles) {
    final String stringContent = File(file.path).readAsStringSync();
    bool started = false;
    String content = '';
    for (int i = 0; i < stringContent.length; i++) {
      final String current = stringContent[i];
      final String next = (i == stringContent.length - 1) ? "" : stringContent[i + 1];
      if (current == "/" && next == "*") {
        started = true;
      } else if (current == "*" && next == "/") {
        started = false;
        i++;
        continue;
      }
      if (started) {
        continue;
      } else {
        content += current;
      }
    }
    File(file.path).writeAsStringSync(content);
    print('Processed: ${file.path}');
  }
}
