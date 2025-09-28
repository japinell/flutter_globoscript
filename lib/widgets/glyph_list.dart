import "package:flutter/material.dart";
import "package:flutter_globoscript/data/script_data.dart" show glyphInfo;

class GlyphListWidget extends StatelessWidget {
  const GlyphListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (var glyph in glyphInfo)
          ListTile(
            leading: Text(
              glyph["glyph"]!,
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            title: Text(glyph["info"]!),
          ),
      ],
    );
  }
}
