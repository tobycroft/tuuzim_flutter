import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class WidgetAudio extends StatelessWidget {
  Track track;

  /// global key so we can pause/resume the player via the api.
  var playerStateKey = GlobalKey<SoundPlayerUIState>();

  Widget build(BuildContext build) {
    var player = SoundPlayerUI.fromTrack(track);
    return Column(
      children: [
        player,
      ],
    );
  }
}
