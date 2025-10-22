import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

import 'accounting_page.dart';
import 'general_support_page.dart';
import 'profile_page.dart';
import 'support_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  late final List<_DashboardTab> _tabs = [
    const _DashboardTab(
      title: 'صفحه کاربری',
      icon: Icons.person_outline,
      content: ProfilePage(),
    ),
    const _DashboardTab(
      title: 'حساب کاربری',
      icon: Icons.account_balance_wallet_outlined,
      content: AccountingPage(),
    ),
    const _DashboardTab(
      title: 'پشتیبانی هلو',
      icon: Icons.support_agent,
      content: SupportPage(),
    ),
    const _DashboardTab(
      title: 'پشتیبانی عمومی',
      icon: Icons.forum_outlined,
      content: GeneralSupportPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(tab.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'بازگشت',
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) => tab.content).toList(growable: false),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon, size: AppSizes.iconMedium),
                label: tab.title,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _DashboardTab {
  const _DashboardTab({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;
  final IconData icon;
  final Widget content;
}
