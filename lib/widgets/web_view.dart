import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url});

  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Web View")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
