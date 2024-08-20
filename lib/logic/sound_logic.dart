import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';

class SoundLogic with CountDataChangedNotifier {
  static const soundDataUp = 'sounds/press_count.mp3';
  static const soundDataDown = 'sounds/press_count.mp3';
  static const soundDataReset = 'sounds/press_reset.mp3';

  final _cache = AudioCache(prefix: 'assets/sounds/');
  final player = AudioPlayer();

  void load() {
    _cache.loadAll([soundDataUp, soundDataDown, soundDataReset]);
  }

  @override
  void valueChanged(CountData oldValue, CountData newValue) {
    if (newValue.countUp == 0 &&
        newValue.countDown == 0 &&
        newValue.count == 0) {
      playResetSound();
    } else if (oldValue.countUp + 1 == newValue.countUp) {
      playUpSound();
    } else if (oldValue.countDown + 1 == newValue.countDown) {
      playDownSound();
    }
  }

  void playUpSound() {
    player.play(AssetSource(soundDataUp));
  }

  void playDownSound() {
    player.play(AssetSource(soundDataDown));
  }

  void playResetSound() {
    player.play(AssetSource(soundDataReset));
  }
}
