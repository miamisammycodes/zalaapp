import 'dart:ui';

extension ColorExt on Color {
  Color brighten(int value) {
    final Color color0 = this;
    final int red = (color0.r + value).toInt();
    final int green = (color0.g + value).toInt();
    final int blue = (color0.b + value).toInt();
    return Color.fromARGB(
      color0.a.toInt(),
      red.clamp(0, 255),
      green.clamp(0, 255),
      blue.clamp(0, 255),
    );
  }

  Color darken(int value) {
    final Color color0 = this;
    final int red = (color0.r - value).toInt();
    final int green = (color0.g - value).toInt();
    final int blue = (color0.b - value).toInt();
    return Color.fromARGB(
      color0.a.toInt(),
      red.clamp(0, 255),
      green.clamp(0, 255),
      blue.clamp(0, 255),
    );
  }
}
