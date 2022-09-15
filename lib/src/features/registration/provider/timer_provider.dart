import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final timerProvider = StateProvider.autoDispose<StopWatchTimer>((ref) => StopWatchTimer(
  mode: StopWatchMode.countDown,
  onEnded: () => print("ended"),
));