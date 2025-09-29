import "package:flutter/material.dart";

class VideoDialogBox extends StatefulWidget {
  const VideoDialogBox({super.key, required this.fileName});

  final String fileName;

  @override
  State<VideoDialogBox> createState() {
    return _VideoDialogBoxState();
  }
}

class _VideoDialogBoxState extends State<VideoDialogBox> {
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
