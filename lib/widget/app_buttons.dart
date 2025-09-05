import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kycapp/widget/app_themes.dart';

/// This file contains reusable button widgets that can be used across the app.
/// Centralizing these button elements improves consistency and reduces code duplication.

/// Primary button with consistent styling
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Text(text, style: AppTextStyles.buttonText),
                  ],
                )
                : Text(text, style: AppTextStyles.buttonText),
      ),
    );
  }
}

/// Secondary (outline) button with consistent styling
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
                : icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
                : Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
      ),
    );
  }
}

/// Text button with consistent styling
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool iconLeading;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child:
          icon != null
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    iconLeading
                        ? [
                          Icon(icon, size: 16),
                          const SizedBox(width: 4),
                          Text(text),
                        ]
                        : [
                          Text(text),
                          const SizedBox(width: 4),
                          Icon(icon, size: 16),
                        ],
              )
              : Text(text),
    );
  }
}

/// Icon button with text
class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? iconSize;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.color,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor, size: iconSize ?? 24),
            const SizedBox(height: 6),
            Text(
              text,
              style: GoogleFonts.poppins(fontSize: 12, color: buttonColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action button for form actions
class FormActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;

  const FormActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? PrimaryButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        )
        : SecondaryButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        );
  }
}

/// Form action buttons row (typically for form actions like Submit/Cancel)
class FormActionButtonRow extends StatelessWidget {
  final String primaryText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;
  final bool isLoading;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;

  const FormActionButtonRow({
    super.key,
    required this.primaryText,
    required this.onPrimaryPressed,
    this.secondaryText,
    this.onSecondaryPressed,
    this.isLoading = false,
    this.primaryIcon,
    this.secondaryIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (secondaryText == null || onSecondaryPressed == null) {
      return PrimaryButton(
        text: primaryText,
        onPressed: onPrimaryPressed,
        isLoading: isLoading,
        icon: primaryIcon,
      );
    }

    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: secondaryText!,
            onPressed: onSecondaryPressed!,
            icon: secondaryIcon,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PrimaryButton(
            text: primaryText,
            onPressed: onPrimaryPressed,
            isLoading: isLoading,
            icon: primaryIcon,
          ),
        ),
      ],
    );
  }
}
