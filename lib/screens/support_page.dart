import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'support_page_embed_stub.dart'
    if (dart.library.html) 'support_page_embed_web.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _webViewType;

  static const Map<String, Object?> _supportConfig = {
    'baseUrl': 'https://holootalk.tnc.ir',
    'baseUrlApi': 'https://holootalk.tnc.ir/api',
    'codeRepresentation': '5200',
    'baseUrl_script': 'https://holootalk.tnc.ir/widget//app.bundle.js',
    'token':
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3aWRnZXRfaWQiOiIwIn0.Etj8q9j8GNNxLmj1QEQ7vWQk3PFw-3-WKW3qWUsM9yYQ0nqtsULLNR571XCt8dJ83uY3YuoLk3NU388V5U3hEP687fys3G-5T2lK4GsVnuCXvMaMaUx4XV1SRMo99nGsEIIcLBmQtpY8XUgZFvY1SCnsE9N1S1wwIeH7e0Kic4DJSj10WENip7eI6YTIg98AlLiG_jJqMpkk8wsi5-sprVCCfy2ou4RD6cxRyblxB2FyKVj__TyUTYqrnjIy-6w87-iNtCoVXlRlwHtbCM_PSyQ0z6v673fJEyEX2Js_XQmwNXljQfbm0s_uAsFtzrdR2FW6dkpYe2xUqhkambKMtX1LwQPkUtXbjq-FmEeAEgQvWWNylt_RYTnB2YXszY8cdwXkw9fe-k6za1liQa7Ahycw6ev24lENBtgWHjDC1_PPXbGopDSyXN9DDV5_TH_L9V7T_xx5nG1yVSIkRHFgeZm-iaTDKvjvA0UVBPlfEdI0ZZ6ysOYKbEl74AgiZT0IIyne0FanBenCXq9T4ecSAMkBQsJkm8L7p6ARlHdeqcnpUtBmlstH1d4YSTHcuLx3qSM7Ia6lY7h7x4dH7bsHlS2JwXhD3UrUXCdKhQ3v1STCzr6EoUycOEEMHrxq83ILhu5-JhoOO-KF8H6daNX3R7RQnHqI6DJW_U6SfIEcPdQ',
    'poll': false,
    'news': false,
    'faq': true,
    'baseUrlApiChatBot': 'https://supportbot.holoobot.com/',
  };

  @override
  void initState() {
    super.initState();

    final htmlDocument = _buildSupportDocument();

    if (kIsWeb) {
      _webViewType = registerSupportIframe(htmlDocument);
      _setLoading(false);
    } else {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _setLoading(true),
            onPageFinished: (_) => _setLoading(false),
          ),
        );
      _controller = controller;
      _loadSupportDocument(controller, htmlDocument);
    }
  }

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => _isLoading = value);
  }

  Future<void> _loadSupportDocument(
    WebViewController controller,
    String document,
  ) async {
    await controller.loadHtmlString(document);
  }

  String _buildSupportDocument() {
    final configJson = jsonEncode(_supportConfig);
    final scriptUrl = _supportConfig['baseUrl_script'] as String? ??
        'https://chatbot.holoobot.com/widget';
    return '''
<!DOCTYPE html>
<html lang="fa">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>پشتیبانی هلو</title>
    <script type="application/json" id="holoo-widget-config">
$configJson
    </script>
    <script src="$scriptUrl" defer></script>
    <style>
      body {
        margin: 0;
        font-family: sans-serif;
        background-color: #f5f5f5;
      }
      #holoo-widget {
        height: 100vh;
      }
    </style>
  </head>
  <body>
    <div id="holoo-widget"></div>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final viewType = _webViewType;
      if (viewType == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox.expand(
        child: HtmlElementView(viewType: viewType),
      );
    }

    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_isLoading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
