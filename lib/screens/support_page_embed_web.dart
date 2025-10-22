// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

String? registerSupportIframe(String htmlContent) {
  final viewType = 'support-iframe-${DateTime.now().microsecondsSinceEpoch}';

  ui.platformViewRegistry.registerViewFactory(viewType, (_) {
    final element = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..srcdoc = htmlContent;
    return element;
  });

  return viewType;
}

String? registerSupportUrl(String url) {
  final viewType = 'support-url-${DateTime.now().microsecondsSinceEpoch}';

  ui.platformViewRegistry.registerViewFactory(viewType, (_) {
    final element = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..src = url;
    return element;
  });

  return viewType;
}
