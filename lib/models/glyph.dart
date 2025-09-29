class Glyph {
  final String glyph;
  final String info;
  final String audio;
  final String video;

  const Glyph({
    required this.glyph,
    required this.info,
    required this.audio,
    required this.video,
  });

  factory Glyph.fromJson(Map<String, dynamic> json) {
    return Glyph(
      glyph: json["glyph"]?.toString() ?? "",
      info: json["info"]?.toString() ?? "",
      audio: json["audio"]?.toString() ?? "",
      video: json["video"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"glyph": glyph, "info": info, "audio": audio, "video": video};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Glyph &&
        other.glyph == glyph &&
        other.info == info &&
        other.audio == audio &&
        other.video == video;
  }

  @override
  int get hashCode =>
      glyph.hashCode ^ info.hashCode ^ audio.hashCode ^ video.hashCode;

  @override
  String toString() {
    return "Glyph(glyph: $glyph, info: $info, audio: $audio, video: $video)";
  }
}
