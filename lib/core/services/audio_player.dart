import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioCache player = AudioCache();

  static beep() {
    player.play('beep.mp3');
  }

  static error() {
    player.play('error.mp3');
  }
}
