import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(
          Icons.account_balance_wallet,
          size: AppSizes.iconLarge + 12,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'نمایش مصرف‌ها و تاریخچه در این بخش',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
