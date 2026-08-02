import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.inputHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                    onChanged?.call('');
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
        ),
      ),
    );
  }
}