import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed; // Changed from VoidCallback to Function()?
  final bool isOutlined;
  final double? width;
  final EdgeInsets? padding;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            side: const BorderSide(color: AppColors.primaryBlue),
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(width ?? double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(width ?? double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );

    if (icon != null) {
      return isOutlined
          ? OutlinedButton.icon(
              style: buttonStyle,
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
            )
          : ElevatedButton.icon(
              style: buttonStyle,
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
            );
    }

    return SizedBox(
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Text(text),
            ),
    );
  }
}
