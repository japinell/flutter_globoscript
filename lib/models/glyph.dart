class Glyph {
  final String glyph;
  final String info;
  final String audio;
  final String video;
  final String web;

  const Glyph({
    required this.glyph,
    required this.info,
    required this.audio,
    required this.video,
    required this.web,
  });

  factory Glyph.fromJson(Map<String, dynamic> json) {
    return Glyph(
      glyph: json["glyph"]?.toString() ?? "",
      info: json["info"]?.toString() ?? "",
      audio: json["audio"]?.toString() ?? "",
      video: json["video"]?.toString() ?? "",
      web: json["web"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "glyph": glyph,
      "info": info,
      "audio": audio,
      "video": video,
      "web": web,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Glyph &&
        other.glyph == glyph &&
        other.info == info &&
        other.audio == audio &&
        other.video == video &&
        other.web == web;
  }

  @override
  int get hashCode =>
      glyph.hashCode ^
      info.hashCode ^
      audio.hashCode ^
      video.hashCode ^
      web.hashCode;

  @override
  String toString() {
    return "Glyph(glyph: $glyph, info: $info, audio: $audio, video: $video, web: $web)";
  }
}
