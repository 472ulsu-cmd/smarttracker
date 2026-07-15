import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Брендовая карточка-контейнер без теней (плоский стиль).
class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        borderRadius: BorderRadius.circular(BrandRadius.md),
        border: Border.all(color: BrandColors.grayLighter),
      ),
      child: child,
    );
  }
}
