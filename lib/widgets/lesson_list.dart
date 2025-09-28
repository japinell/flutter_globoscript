import "package:flutter/material.dart";
import "package:flutter_globoscript/data/script_data.dart" show lessonInfo;

class LessonListWidget extends StatelessWidget {
  const LessonListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (var lesson in lessonInfo)
          ListTile(
            leading: Text(
              lesson["code"]!,
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            title: Text(lesson["name"]!),
          ),
      ],
    );
  }
}
