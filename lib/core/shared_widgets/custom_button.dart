import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

enum ButtonType { solid, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.solid,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.solid
                    ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                    : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: type == ButtonType.solid
                  ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                  : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            ),
            const SizedBox(width: 8),
          ],
        ],
        Text(
          text.toUpperCase(),
          style: type == ButtonType.solid
              ? theme.textTheme.labelLarge
              : theme.textTheme.labelLarge?.copyWith(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
        ),
      ],
    );

    Widget buildButton() {
      switch (type) {
        case ButtonType.outline:
          return OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppTheme.outlineStyle(context),
            child: buttonContent,
          );
        case ButtonType.text:
          return TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: buttonContent,
          );
        case ButtonType.solid:
        default:
          return ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppTheme.elevatedStyle(context),
            child: buttonContent,
          );
      }
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: buildButton(),
    );
  }
}
