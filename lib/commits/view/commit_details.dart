import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  late WebViewWidget webview;
  final GlobalKey webViewKey = GlobalKey();
  late final WebViewController _controller;
  bool isLoading = true;

  Future<void> reloadPage() async {
    if (!kIsWeb) {
      _controller.reload();
    }
  }

  void initializeWebview() {
    late final PlatformWebViewControllerCreationParams params;
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

    webview = WebViewWidget(controller: _controller);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    initializeWebview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await reloadPage();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: kIsWeb
          ? const Center(
              child: Text("Webview is not supported on web"),
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : webview,
    );
  }
}
