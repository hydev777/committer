import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class CommitDetailsView extends StatefulWidget {
  const CommitDetailsView({
    super.key,
    this.url,
  });

  final String? url;

  @override
  State<CommitDetailsView> createState() => _CommitDetailsViewState();
}

class _CommitDetailsViewState extends State<CommitDetailsView> {
  final GlobalKey webViewKey = GlobalKey();
  late final WebViewController _controller;

  void reloadPage() async {
    _controller.reload();
  }

  void initializeWebviewController() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url!));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeWebviewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              reloadPage();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
