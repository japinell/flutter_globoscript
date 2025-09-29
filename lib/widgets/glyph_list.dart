import "dart:convert";

import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:flutter_globoscript/models/glyph.dart";
import "package:flutter_globoscript/widgets/video_dialog.dart";
import "package:flutter_globoscript/widgets/web_view.dart";

class GlyphListWidget extends StatefulWidget {
  const GlyphListWidget({super.key});

  @override
  State<GlyphListWidget> createState() => _GlyphListWidgetState();
}

class _GlyphListWidgetState extends State<GlyphListWidget> {
  late AudioPlayer _player;
  late Future<List<Glyph>> _glyphsFuture;
  bool _isGlyphsLoaded = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load glyphs once when dependencies change
    if (!_isGlyphsLoaded) {
      _glyphsFuture = _loadGlyphs(context);
      _isGlyphsLoaded = true;
    }
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<List<Glyph>> _loadGlyphs(BuildContext context) async {
    String glyphsJson = await DefaultAssetBundle.of(
      context,
    ).loadString("assets/config/glyphs.json");
    final glyphsList = json.decode(glyphsJson) as List<dynamic>;
    return glyphsList
        .cast<Map<String, dynamic>>()
        .map((e) => Glyph.fromJson(e))
        .toList();
  }

  Future<void> _playAudio(String audioFile) async {
    if (_player.state != PlayerState.playing) {
      await _player.play(AssetSource("audio/glyphs/$audioFile"));
    }
  }

  Future<void> _playVideo(String videoFile) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoDialogBox(fileName: "assets/video/glyphs/$videoFile");
      },
    );
  }

  Future<void> _showWebContent(String url) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url, title: "Glyph Info"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Glyph>>(
      future: _glyphsFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading glyphs...", style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Failed to load glyphs",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _glyphsFuture = _loadGlyphs(context);
                    });
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, color: Colors.grey, size: 64),
                SizedBox(height: 16),
                Text(
                  "No glyphs available",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // Success state
        final glyphInfo = snapshot.data!;

        return ListView.builder(
          itemCount: glyphInfo.length,
          itemBuilder: (context, index) {
            final glyph = glyphInfo[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      glyph.glyph.isNotEmpty ? glyph.glyph : "?",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  glyph.info.isNotEmpty ? glyph.info : "No info available",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (glyph.audio.isNotEmpty) {
                          _playAudio(glyph.audio);
                        }
                      },
                      icon: const Icon(Icons.play_circle_outline),
                      color: Colors.orange,
                      tooltip: glyph.audio.isNotEmpty
                          ? "Play audio"
                          : "No audio available",
                    ),
                    IconButton(
                      onPressed: () {
                        if (glyph.video.isNotEmpty) {
                          _playVideo(glyph.video);
                        }
                      },
                      icon: const Icon(Icons.videocam_rounded),
                      color: Colors.teal,
                      tooltip: glyph.video.isNotEmpty
                          ? "Play video"
                          : "No video available",
                    ),
                    IconButton(
                      onPressed: () {
                        if (glyph.web.isNotEmpty) {
                          _showWebContent(glyph.web);
                        }
                      },
                      icon: const Icon(Icons.web),
                      color: Colors.deepPurple,
                      tooltip: glyph.web.isNotEmpty
                          ? "Show web content"
                          : "No web content available",
                    ),
                  ],
                ),
                onTap: () {
                  if (glyph.audio.isNotEmpty) {
                    _playAudio(glyph.audio);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
