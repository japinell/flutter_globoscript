import "package:flutter/material.dart";
import "package:flutter_globoscript/utils/webview_utils.dart";
import "package:flutter_globoscript/widgets/web_view.dart";

/// Example usage of the enhanced WebView widget
class WebViewExamplePage extends StatelessWidget {
  const WebViewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebView Examples")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "WebView Examples",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Basic WebView
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      url: "https://flutter.dev",
                      title: "Flutter.dev",
                    ),
                  ),
                );
              },
              child: const Text("Open Flutter.dev"),
            ),

            const SizedBox(height: 12),

            // WebView without app bar
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      url: "https://dart.dev",
                      title: "Dart.dev",
                      showAppBar: false,
                      showNavigationControls: true,
                    ),
                  ),
                );
              },
              child: const Text("Open Dart.dev (No App Bar)"),
            ),

            const SizedBox(height: 12),

            // WebView in dialog
            ElevatedButton(
              onPressed: () {
                WebViewUtils.showWebViewDialog(
                  context,
                  url: "https://pub.dev",
                  title: "Pub.dev",
                  fullScreen: false,
                );
              },
              child: const Text("Open Pub.dev in Dialog"),
            ),

            const SizedBox(height: 12),

            // WebView with URL validation
            ElevatedButton(
              onPressed: () {
                _showUrlInputDialog(context);
              },
              child: const Text("Enter Custom URL"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Features Included:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("✓ Loading progress indicator"),
                    Text("✓ Navigation controls (back/forward/refresh)"),
                    Text("✓ Error handling with retry option"),
                    Text("✓ JavaScript channel communication"),
                    Text("✓ Customizable app bar and navigation"),
                    Text("✓ URL validation"),
                    Text("✓ Configurable display options"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlInputDialog(BuildContext context) {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter URL"),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: "URL",
            hintText: "https://example.com",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              Navigator.pop(context);

              if (url.isNotEmpty) {
                if (WebViewUtils.isValidUrl(WebViewUtils.normalizeUrl(url))) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                        url: WebViewUtils.normalizeUrl(url),
                        title: WebViewUtils.extractDomain(url) ?? "Web Page",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid URL"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }
}
