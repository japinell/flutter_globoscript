import "package:flutter/material.dart";
import "package:flutter_globoscript/widgets/web_view.dart";

class WebViewUtils {
  /// Validates if a given URL is properly formatted
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == "http" || uri.scheme == "https");
    } catch (e) {
      return false;
    }
  }

  /// Adds protocol to URL if missing
  static String normalizeUrl(String url) {
    if (url.isEmpty) return url;

    // If no protocol is specified, default to https
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      return "https://$url";
    }

    return url;
  }

  /// Extracts domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Shows a dialog to open URL in WebView
  static Future<void> showWebViewDialog(
    BuildContext context, {
    required String url,
    String? title,
    bool fullScreen = false,
  }) async {
    if (!isValidUrl(normalizeUrl(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid URL provided"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (fullScreen) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              WebViewPage(url: normalizeUrl(url), title: title),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: WebViewPage(
              url: normalizeUrl(url),
              title: title,
              showNavigationControls: true,
            ),
          ),
        ),
      );
    }
  }

  /// JavaScript code to inject for better Flutter integration
  static const String flutterIntegrationJS = """
    // Add Flutter integration functions
    window.flutterChannel = {
      postMessage: function(message) {
        if (window.FlutterChannel && window.FlutterChannel.postMessage) {
          window.FlutterChannel.postMessage(message);
        }
      }
    };
    
    // Notify Flutter when page is ready
    document.addEventListener('DOMContentLoaded', function() {
      if (window.flutterChannel) {
        window.flutterChannel.postMessage('page_ready');
      }
    });
  """;
}
