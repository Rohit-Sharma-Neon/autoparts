import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebViewWidget extends StatefulWidget {
  final String? url;

  const WebViewWidget({Key? key,this.url}) : super(key: key);



  @override
  _WebViewWidget createState() => _WebViewWidget();
}

class _WebViewWidget extends State<WebViewWidget> {
  WebView? _webView;
  @override
  void initState() {
    super.initState();
    _webView = WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _webView = null;
  }

  @override
  Widget build(BuildContext context) => _webView!;
}