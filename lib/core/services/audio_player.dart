import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer player = AudioPlayer();

  static beep() {
    player.play(AssetSource('beep.mp3'));
  }

  static error() {
    player.play(AssetSource('error.mp3'));
  }
}
