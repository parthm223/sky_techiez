import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodySmall,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            border: theme.inputDecorationTheme.border,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
            errorBorder: theme.inputDecorationTheme.errorBorder,
            contentPadding: theme.inputDecorationTheme.contentPadding,
          ),
        ),
      ],
    );
  }
}
