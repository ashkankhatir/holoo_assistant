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
  static const String _supportUrl =
      'https://chatbot.holoobot.com/widget/customer/general/mobile';

  WebViewController? _controller;
  String? _webViewType;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _webViewType = registerSupportUrl(_supportUrl);
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
        )
        ..loadRequest(Uri.parse(_supportUrl));
      _controller = controller;
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
    if (kIsWeb) {
      setState(() {
        _hasError = false;
        _webViewType = registerSupportUrl(_supportUrl);
      });
    } else if (_controller != null) {
      setState(() {
        _hasError = false;
        _isLoading = true;
      });
      await _controller!.loadRequest(Uri.parse(_supportUrl));
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(_supportUrl);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'اگر محتوای پشتیبانی نمایش داده نمی‌شود، می‌توانید آن را در مرورگر باز کنید.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _openExternally,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('باز کردن در مرورگر'),
                ),
              ],
            ),
          ),
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
            'ارتباط با chatbot.holoobot.com برقرار نشد.',
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
