import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onSelected;

  const FilterChipsWidget({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          return ChoiceChip(
            label: Text(option),
            selected: isSelected,
            onSelected: (_) => onSelected(isSelected ? null : option),
            backgroundColor: colors.chipBackground,
            selectedColor: colors.chipSelectedBackground,
            labelStyle: TextStyle(
              color: isSelected ? colors.chipSelectedText : colors.chipText,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }
}
