import 'package:flutter/material.dart';

import '../../../../app/common/formatters.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/portion_guide.dart';

class PortionTable extends StatelessWidget {
  const PortionTable({super.key, required this.portions});

  final List<PortionGuide> portions;

  @override
  Widget build(BuildContext context) {
    final caption = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: AppColors.ink.withValues(alpha: 0.7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Por dia, conforme o peso do pet.', style: caption),
        const SizedBox(height: AppSpacing.sm),
        for (final portion in portions) _row(context, portion),
      ],
    );
  }

  Widget _row(BuildContext context, PortionGuide portion) {
    final style = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.ink);

    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(_range(portion), style: style)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                '${portion.gramsPerDay} g por dia',
                style: style,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _range(PortionGuide portion) {
    final minWeight = formatWeightKg(portion.minWeightKg);
    final maxWeight = portion.maxWeightKg;
    if (maxWeight == null) {
      return '$minWeight ou mais';
    }
    return '$minWeight a ${formatWeightKg(maxWeight)}';
  }
}
