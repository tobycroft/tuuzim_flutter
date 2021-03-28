import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class WidgetAudio extends StatelessWidget {
  Track track;
  String file;

  WidgetAudio(this.file);

  /// global key so we can pause/resume the player via the api.
  var playerStateKey = GlobalKey<SoundPlayerUIState>();

  Widget build(BuildContext build) {
    this.track = Track(trackPath: this.file);
    return SoundPlayerUI.fromTrack(track);
  }
}
