import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            Icons.person,
            size: AppSizes.iconLarge,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'اطلاعات پروفایل کاربر اینجا قرار می‌گیرد',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
