import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'support_page_embed_stub.dart'
    if (dart.library.html) 'support_page_embed_web.dart';

class GeneralSupportPage extends StatefulWidget {
  const GeneralSupportPage({super.key});

  @override
  State<GeneralSupportPage> createState() => _GeneralSupportPageState();
}

class _GeneralSupportPageState extends State<GeneralSupportPage> {
  static const Map<String, Object?> _supportConfig = {
    'baseUrl': 'https://holootalk.tnc.ir',
    'baseUrlApi': 'https://sales.tnc.ir/faq',
    'baseUrl_script': 'https://holootalk.tnc.ir/widget/',
    'baseUrlApiChatBot': 'https://supportbot.holoobot.com/',
    'token':
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3aWRnZXRfaWQiOiIwIn0.Etj8q9j8GNNxLmj1QEQ7vWQk3PFw-3-WKW3qWUsM9yYQ0nqtsULLNR571XCt8dJ83uY3YuoLk3NU388V5U3hEP687fys3G-5T2lK4GsVnuCXvMaMaUx4XV1SRMo99nGsEIIcLBmQtpY8XUgZFvY1SCnsE9N1S1wwIeH7e0Kic4DJSj10WENip7eI6YTIg98AlLiG_jJqMpkk8wsi5-sprVCCfy2ou4RD6cxRyblxB2FyKVj__TyUTYqrnjIy-6w87-iNtCoVXlRlwHtbCM_PSyQ0z6v673fJEyEX2Js_XQmwNXljQfbm0s_uAsFtzrdR2FW6dkpYe2xUqhkambKMtX1LwQPkUtXbjq-FmEeAEgQvWWNylt_RYTnB2YXszY8cdwXkw9fe-k6za1liQa7Ahycw6ev24lENBtgWHjDC1_PPXbGopDSyXN9DDV5_TH_L9V7T_xx5nG1yVSIkRHFgeZm-iaTDKvjvA0UVBPlfEdI0ZZ6ysOYKbEl74AgiZT0IIyne0FanBenCXq9T4ecSAMkBQsJkm8L7p6ARlHdeqcnpUtBmlstH1d4YSTHcuLx3qSM7Ia6lY7h7x4dH7bsHlS2JwXhD3UrUXCdKhQ3v1STCzr6EoUycOEEMHrxq83ILhu5-JhoOO-KF8H6daNX3R7RQnHqI6DJW_U6SfIEcPdQ',
    'faq': true,
    'news': true,
    'poll': true,
    'zIndex': 9999999999,
  };

  static const String _fallbackUrl = 'https://holootalk.tnc.ir/widget/';

  WebViewController? _controller;
  String? _webViewType;
  bool _isLoading = true;
  bool _hasError = false;

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
            onWebResourceError: (_) => _handleError(),
          ),
        );
      _controller = controller;
      _setLoading(true);
      _loadSupportDocument(controller, htmlDocument);
    }
  }

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => _isLoading = value);
  }

  void _handleError() {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }

  Future<void> _reload() async {
    final htmlDocument = _buildSupportDocument();
    if (kIsWeb) {
      setState(() {
        _hasError = false;
        _webViewType = registerSupportIframe(htmlDocument);
      });
    } else if (_controller != null) {
      setState(() {
        _hasError = false;
        _isLoading = true;
      });
      await _loadSupportDocument(_controller!, htmlDocument);
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(_fallbackUrl);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  Future<void> _loadSupportDocument(
    WebViewController controller,
    String document,
  ) async {
    try {
      await controller.loadHtmlString(document);
    } catch (_) {
      _handleError();
    }
  }

  String _buildSupportDocument() {
    final configJson = jsonEncode(_supportConfig);
    return '''
<!DOCTYPE html>
<html lang="fa">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>پشتیبانی عمومی</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        font-family: sans-serif;
      }
      #holoo-widget {
        min-height: 100vh;
      }
    </style>
  </head>
  <body>
    <script type="application/json" id="holoo-widget-config">$configJson</script>
    <script>
      (function () {
        var configElement = document.getElementById('holoo-widget-config');
        if (!configElement) {
          return;
        }
        var config = JSON.parse(configElement.textContent || '{}');
        var container = document.getElementById('holoo-widget-container');
        if (!container) {
          container = document.createElement('div');
          container.id = 'holoo-widget-container';
          container.style.width = '100%';
          container.style.height = '100vh';
          container.style.margin = '0 auto';
          container.style.position = 'relative';
          var body = document.body || document.getElementsByTagName('body')[0];
          if (body) {
            body.appendChild(container);
          }
        }
        var head = document.head || document.getElementsByTagName('head')[0] || document.documentElement;
        var script = document.createElement('script');
        var base = config.baseUrl_script || '';
        if (base && base.charAt(base.length - 1) !== '/') {
          base += '/';
        }
        script.src = base + 'app.bundle.js';
        script.async = true;
        script.onload = function () {
          if (window.WebChat && typeof window.WebChat.selfMount === 'function') {
            window.WebChat.selfMount({
              faq: config.faq !== undefined ? config.faq : false,
              news: config.news !== undefined ? config.news : false,
              poll: config.poll !== undefined ? config.poll : false,
              zIndex: config.zIndex || 9999999999,
              baseUrl: config.baseUrl,
              baseUrlApi: config.baseUrlApi,
              baseUrlApiChatBot: config.baseUrlApiChatBot,
              token: config.token
            }, container);
          }
        };
        script.onerror = function () {
          document.body.setAttribute('data-widget-error', 'true');
        };
        if (head) {
          head.insertBefore(script, head.firstChild);
        } else if (container) {
          container.appendChild(script);
        }
      })();
    </script>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final viewType = _webViewType;
      return Column(
        children: [
          Expanded(
            child: viewType == null
                ? const Center(child: CircularProgressIndicator())
                : HtmlElementView(viewType: viewType),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Column(
          //     children: [
          //       const Text(
          //         'اگر محتوای پشتیبانی نمایش داده نمی‌شود، می‌توانید آن را در مرورگر باز کنید.',
          //         textAlign: TextAlign.center,
          //       ),
          //       const SizedBox(height: 12),
          //       ElevatedButton.icon(
          //         onPressed: _openExternally,
          //         icon: const Icon(Icons.open_in_new),
          //         label: const Text('باز کردن در مرورگر'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
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
        if (_hasError)
          _SupportErrorOverlay(
            onReload: () {
              _reload();
            },
            onOpenExternally: () {
              _openExternally();
            },
          ),
      ],
    );
  }
}

class _SupportErrorOverlay extends StatelessWidget {
  const _SupportErrorOverlay({
    required this.onReload,
    required this.onOpenExternally,
  });

  final VoidCallback onReload;
  final VoidCallback onOpenExternally;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'ارتباط با holootalk.tnc.ir برقرار نشد.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'لطفاً اتصال اینترنت را بررسی کنید یا از دکمه زیر برای باز کردن در مرورگر استفاده کنید.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onReload,
            icon: const Icon(Icons.refresh),
            label: const Text('تلاش مجدد'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onOpenExternally,
            icon: const Icon(Icons.open_in_new),
            label: const Text('باز کردن در مرورگر'),
          ),
        ],
      ),
    );
  }
}
