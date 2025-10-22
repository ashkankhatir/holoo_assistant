import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/dashboard_page.dart';

void main() {
  HolooWidgetsBinding.ensureInitialized();
  runApp(const HolooAssistantApp());
}

class HolooAssistantApp extends StatelessWidget {
  const HolooAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holoo Assistant',
      theme: AppTheme.light,
      home: const SplashPage(),
    );
  }
}

// Simple splash that shows an assistant icon and navigates to login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assistant,
              size: 96,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Holoo Assistant',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter phone number')));
      return;
    }
    // For demo: navigate to OTP screen. In real app call backend to send OTP.
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => OtpPage(phone: phone)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('ورود')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'شماره تلفن خود را وارد کنید',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '09xxxxxxxx',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendOtp,
              child: const Text('دریافت کد'),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کد ۶ رقمی را وارد کنید')));
      return;
    }
    // Demo: assume OTP is valid. In real app validate with server.
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تایید کد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('کد ارسال شده به ${widget.phone} را وارد کنید',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '۶ رقم کد',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _verify, child: const Text('تایید')),
          ],
        ),
      ),
    );
  }
}

class HolooWidgetsBinding extends WidgetsFlutterBinding {
  static HolooWidgetsBinding ensureInitialized() {
    try {
      final WidgetsBinding binding = WidgetsBinding.instance;
      if (binding is HolooWidgetsBinding) {
        return binding;
      }
    } on FlutterError {
      // Binding not yet initialized; will create a new instance below.
    }
    return HolooWidgetsBinding();
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    super.handlePointerEvent(_downgradeTrackpadEvents(event));
  }

  PointerEvent _downgradeTrackpadEvents(PointerEvent event) {
    if (event.kind != PointerDeviceKind.trackpad) {
      return event;
    }

    if (event is PointerPanZoomStartEvent ||
        event is PointerPanZoomUpdateEvent ||
        event is PointerPanZoomEndEvent) {
      return event;
    }

    if (event is PointerAddedEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerRemovedEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerEnterEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerExitEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerDownEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerMoveEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerUpEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerHoverEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerScrollEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerScaleEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    if (event is PointerCancelEvent) {
      return event.copyWith(kind: PointerDeviceKind.mouse);
    }
    return event;
  }
}
