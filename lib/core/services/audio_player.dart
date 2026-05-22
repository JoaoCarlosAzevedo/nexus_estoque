import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer player = AudioPlayer();

  static void beep() {
    player.play(AssetSource('beep.mp3'));
  }

  static void error() {
    player.play(AssetSource('error.mp3'));
  }
}
