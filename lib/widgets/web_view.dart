import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.url,
    this.title,
    this.showAppBar = true,
    this.showNavigationControls = true,
  });

  final String url;
  final String? title;
  final bool showAppBar;
  final bool showNavigationControls;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  int _loadingProgress = 0;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
            await _updateNavigationState();
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // You can add custom navigation logic here
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        "FlutterChannel",
        onMessageReceived: (JavaScriptMessage message) {
          // Handle messages from JavaScript
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("JS Message: ${message.message}")),
          );
        },
      );

    _loadUrl();
  }

  Future<void> _loadUrl() async {
    try {
      final uri = Uri.parse(widget.url);
      await _controller.loadRequest(uri);
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "Invalid URL: ${widget.url}";
        _isLoading = false;
      });
    }
  }

  Future<void> _updateNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _refresh() async {
    await _controller.reload();
  }

  Future<void> _goBack() async {
    if (_canGoBack) {
      await _controller.goBack();
      await _updateNavigationState();
    }
  }

  Future<void> _goForward() async {
    if (_canGoForward) {
      await _controller.goForward();
      await _updateNavigationState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: Column(
        children: [
          if (_isLoading) _buildProgressIndicator(),
          if (widget.showNavigationControls) _buildNavigationBar(),
          Expanded(child: _buildWebViewContent()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.title ?? "Web View"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refresh,
          tooltip: "Refresh",
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: _loadingProgress / 100.0,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _canGoBack ? _goBack : null,
            tooltip: "Go Back",
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _canGoForward ? _goForward : null,
            tooltip: "Go Forward",
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: "Refresh",
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewContent() {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return WebViewWidget(controller: _controller);
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "Failed to load page",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _loadUrl();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
