import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kycapp/widget/app_themes.dart';

/// This file contains reusable layout widgets that can be used across the app.
/// Centralizing these layout elements improves consistency and reduces code duplication.

/// Screen container with standard padding and background
class ScreenContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;

  const ScreenContainer({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          title != null
              ? AppBar(
                title: Text(
                  title!,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                automaticallyImplyLeading: showBackButton,
                actions: actions,
              )
              : null,
      body: SafeArea(child: child),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? AppColors.lightBackground,
    );
  }
}

/// Scrollable content container with standard padding
class ScrollableContentContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ScrollableContentContainer({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(16),
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          children: children,
        ),
      ),
    );
  }
}

/// Content section with title and children
class ContentSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final String? subtitle;

  const ContentSection({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.only(bottom: 24),
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(subtitle!, style: AppTextStyles.bodySmall),
            ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Card container with consistent styling
class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: container,
      );
    }

    return container;
  }
}

/// Grid layout for equal-width items
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double minItemWidth;
  final double maxItemWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.spacing = 16,
    this.minItemWidth = 150,
    this.maxItemWidth = 300,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          int crossAxisCount = (availableWidth / minItemWidth).floor();
          crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

          double itemWidth = availableWidth / crossAxisCount;
          itemWidth = itemWidth > maxItemWidth ? maxItemWidth : itemWidth;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children:
                children.map((widget) {
                  return SizedBox(width: itemWidth - spacing, child: widget);
                }).toList(),
          );
        },
      ),
    );
  }
}

/// Horizontal scrollable list with title
class HorizontalScrollSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? subtitle;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;

  const HorizontalScrollSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.itemSpacing = 16,
    this.padding = const EdgeInsets.only(bottom: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(subtitle!, style: AppTextStyles.bodySmall),
            ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1) SizedBox(width: itemSpacing),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator with optional message
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingIndicator({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state placeholder
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              TextButton(onPressed: onActionPressed, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
