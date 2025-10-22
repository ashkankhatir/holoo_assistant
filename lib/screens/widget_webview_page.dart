import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WidgetWebViewPage extends StatefulWidget {
  const WidgetWebViewPage({super.key});

  @override
  State<WidgetWebViewPage> createState() => _WidgetWebViewPageState();
}

class _WidgetWebViewPageState extends State<WidgetWebViewPage> {
  final String widgetUrl =
      'https://holootalk.tnc.ir/widget/customer/general/mobile';
  WebViewController? _controller;
  bool _isLoading = true;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _setLoading(true),
            onPageFinished: (_) async {
              _setLoading(false);
              await _refreshBackAvailability();
            },
            onNavigationRequest: (request) {
              // Allow all in-app navigation for now.
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widgetUrl));
    }
  }

  Future<void> _refreshBackAvailability() async {
    if (_controller == null) return;
    final canGoBack = await _controller!.canGoBack();
    if (mounted) {
      setState(() => _canGoBack = canGoBack);
    }
  }

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => _isLoading = value);
  }

  Future<void> _handleWebViewBack() async {
    if (_controller == null) return;
    if (await _controller!.canGoBack()) {
      await _controller!.goBack();
      await _refreshBackAvailability();
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = kIsWeb
        ? _WebFallbackButton(widgetUrl: widgetUrl)
        : _controller == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  WebViewWidget(controller: _controller!),
                  if (_isLoading)
                    const Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(),
                    ),
                ],
              );

    return PopScope(
      canPop: _controller == null ? true : !_canGoBack,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleWebViewBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ویجت پشتیبانی'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'بستن',
          ),
          actions: [
            if (!kIsWeb)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _canGoBack ? _handleWebViewBack : null,
                tooltip: 'بازگشت در صفحه',
              ),
            if (!kIsWeb)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_controller != null) {
                    _controller!.reload();
                    _setLoading(true);
                  }
                },
                tooltip: 'بارگذاری مجدد',
              ),
          ],
        ),
        body: body,
      ),
    );
  }
}

class _WebFallbackButton extends StatelessWidget {
  final String widgetUrl;
  const _WebFallbackButton({required this.widgetUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.maybeOf(context);
          final uri = Uri.parse(widgetUrl);
          final canLaunch = await canLaunchUrl(uri);
          if (canLaunch) {
            await launchUrl(uri, webOnlyWindowName: '_self');
          } else {
            messenger?.showSnackBar(
              const SnackBar(content: Text('امکان باز کردن آدرس وجود ندارد')),
            );
          }
        },
        child: const Text('باز کردن ویجت در مرورگر'),
      ),
    );
  }
}
