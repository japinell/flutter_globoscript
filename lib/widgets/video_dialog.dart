import "package:flutter/material.dart";
import "package:video_player/video_player.dart";

class VideoDialogBox extends StatefulWidget {
  const VideoDialogBox({super.key, required this.fileName});

  final String fileName;

  @override
  State<VideoDialogBox> createState() {
    return _VideoDialogBoxState();
  }
}

class _VideoDialogBoxState extends State<VideoDialogBox> {
  VideoPlayerController? _controller;
  bool _playClicked = false;
  final bool _pauseClicked = false;
  bool _replayClicked = false;
  final bool _slowClicked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.fileName);
    _controller?.initialize().then((_) {
      _controller?.play();
    });
    _controller?.addListener(() {
      if (_replayClicked ||
          (_playClicked &&
              (_controller?.value.position == _controller?.value.duration))) {
        _controller?.seekTo(Duration.zero);
      }

      setState(() {
        _playClicked = false;
        _replayClicked = false;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Stroke Order"),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.pause)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.replay)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.slow_motion_video)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
      ],
    );
  }
}
