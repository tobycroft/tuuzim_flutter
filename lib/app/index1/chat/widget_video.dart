import 'package:cached_video_player/cached_video_player.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class WidgetVideo extends StatefulWidget {
  String img;
  String video;

  WidgetVideo(this.img, this.video);

  @override
  _VideoAppState createState() => _VideoAppState(this.img, this.video);
}

class _VideoAppState extends State<WidgetVideo> {
  CachedVideoPlayerController _controller;

  String img;
  String video;

  _VideoAppState(this.img, this.video);

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network(this.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? Container(
                child: GestureDetector(
                  child: CachedVideoPlayer(_controller),
                  onTap: () {
                    Windows.Close(context);
                  },
                ),
              )
            : Container(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              Windows.Close(context);
            },
            child: Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
