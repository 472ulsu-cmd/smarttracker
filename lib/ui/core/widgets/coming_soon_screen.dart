import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';

/// Заглушка экрана, который будет реализован в следующих этапах.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 56,
                color: BrandColors.primary,
              ),
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Этот экран будет реализован в следующем этапе.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: BrandColors.grayMid,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
