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
  bool _replayClicked = false;
  bool _slowPlay = false;

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

      _playClicked = false;
      _replayClicked = false;
      _slowPlay = false;

      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Stroke Order", textAlign: TextAlign.center),
      content: _controller != null && _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading video...", style: TextStyle(fontSize: 16)),
              ],
            ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _playClicked = true;
                  _replayClicked = false;
                  _slowPlay = false;

                  if (_controller?.value.isPlaying ?? false) {
                    _controller?.pause();
                  } else {
                    _controller?.setPlaybackSpeed(1.0);
                    _controller?.play();
                  }
                },
                icon: Icon(
                  _controller?.value.isPlaying ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              IconButton(
                onPressed: () {
                  _replayClicked = true;
                  _playClicked = false;
                  _slowPlay = false;
                  _controller?.seekTo(Duration.zero);
                  _controller?.play();
                },
                icon: const Icon(Icons.replay),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _slowPlay = true;
                    _playClicked = false;
                    _replayClicked = false;

                    if (_controller != null && !_controller!.value.isPlaying) {
                      _playClicked = true;
                      _controller?.seekTo(Duration.zero);
                      _controller?.setPlaybackSpeed(0.5);
                      _controller?.play();
                    }
                  });
                },
                icon: const Icon(Icons.slow_motion_video),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
