import 'dart:math';

String generateId() {
  final rnd = Random();
  final millis = DateTime.now().millisecondsSinceEpoch;
  final suffix = rnd.nextInt(99999);
  return '${millis}_$suffix';
}
