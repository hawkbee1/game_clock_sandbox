/// Design Pattern: Single Responsibility
/// A pure utility function dedicated solely to formatting [Duration] objects
/// into a human-readable "MM:SS:CC" string (minutes, seconds, centiseconds).
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  final centiseconds = twoDigits(
    duration.inMilliseconds.remainder(1000) ~/ 10,
  );
  return '$minutes:$seconds:$centiseconds';
}
