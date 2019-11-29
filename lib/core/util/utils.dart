/// Returns a human-readable representation of a duration
String prettyPrintDuration(Duration duration, [showSeparator = true]){
  final hours = duration.inHours % 24;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  final separator = showSeparator ? ':' : ' ';
  return '$hours$separator${prettyPrintDigits(minutes)}$separator${prettyPrintDigits(seconds)}';
}
String prettyPrintDigits(int num) => num >= 10 ? '$num' : '0$num';
