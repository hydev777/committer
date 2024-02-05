import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
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
  var webview;
  final GlobalKey webViewKey = GlobalKey();
  late final WebViewController _controller;

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

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url!));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    webview = WebViewWidget(controller: _controller);
  }

  void initializeWebViewInWeb() {
    webview = const Center(
      child: Text("Webview is not supported on web"),
    );
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      initializeWebViewInWeb();
    } else {
      initializeWebview();
    }
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
      body: webview,
    );
  }
}
