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

enum ActiveButton { none, play, replay, slowMotion }

class _VideoDialogBoxState extends State<VideoDialogBox> {
  VideoPlayerController? _controller;
  ActiveButton _activeButton = ActiveButton.play;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.fileName);
    _controller?.initialize().then((_) {
      _controller?.play();
    });
    _controller?.addListener(() {
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
                  setState(() {
                    _activeButton = ActiveButton.play;
                    if (_controller?.value.isPlaying ?? false) {
                      _controller?.pause();
                    } else {
                      _controller?.setPlaybackSpeed(1.0);
                      _controller?.play();
                    }
                  });
                },
                icon: Icon(
                  _controller?.value.isPlaying ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: _activeButton == ActiveButton.play
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _activeButton = ActiveButton.replay;
                    _controller?.seekTo(Duration.zero);
                    _controller?.play();
                  });
                },
                icon: Icon(
                  Icons.replay,
                  color: _activeButton == ActiveButton.replay
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _activeButton = ActiveButton.slowMotion;
                    if (_controller != null) {
                      _controller?.seekTo(Duration.zero);
                      _controller?.setPlaybackSpeed(0.5);
                      _controller?.play();
                    }
                  });
                },
                icon: Icon(
                  Icons.slow_motion_video,
                  color: _activeButton == ActiveButton.slowMotion
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
