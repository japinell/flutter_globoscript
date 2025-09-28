import "package:flutter/material.dart";
import "package:flutter_globoscript/widgets/community.dart";
import "package:flutter_globoscript/widgets/contact.dart";
import "package:flutter_globoscript/widgets/glyph_list.dart";
import "package:flutter_globoscript/widgets/lesson_list.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GloboScript",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.toc)),
                Tab(icon: Icon(Icons.school)),
                Tab(icon: Icon(Icons.connect_without_contact)),
                Tab(icon: Icon(Icons.mail_outline)),
              ],
            ),
            title: Text("GloboScript"),
          ),
          body: TabBarView(
            children: [
              GlyphListWidget(),
              LessonListWidget(),
              CommunityWidget(),
              ContactWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
