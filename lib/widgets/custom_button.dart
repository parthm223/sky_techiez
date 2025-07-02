import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isOutlined;
  final double? width;
  final EdgeInsets? padding;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width,
    this.padding,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final buttonStyle = isOutlined
        ? theme.outlinedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all(
              padding ?? const EdgeInsets.symmetric(vertical: 16)
            ),
            minimumSize: WidgetStateProperty.all(
              Size(width ?? double.infinity, 48)
            ),
          )
        : theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.all(
              backgroundColor ?? theme.primaryColor
            ),
            padding: WidgetStateProperty.all(
              padding ?? const EdgeInsets.symmetric(vertical: 16)
            ),
            minimumSize: WidgetStateProperty.all(
              Size(width ?? double.infinity, 48)
            ),
          );

    // Show loading indicator if isLoading is true
    final child = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: isOutlined ? theme.primaryColor : Colors.white,
              strokeWidth: 2,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text);

    if (icon != null && !isLoading) {
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
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: child,
            ),
    );
  }
}
