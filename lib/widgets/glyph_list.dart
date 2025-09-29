import "dart:convert";

import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:flutter_globoscript/models/glyph.dart";

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
            return ListTile(
              leading: Text(
                glyphInfo[index].glyph,
                style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
              ),
              title: Text(glyphInfo[index].info),
            );
          },
        );
      },
    );
  }
}
