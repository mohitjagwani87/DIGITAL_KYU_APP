import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// A reusable app bar with tutorial info button for service pages
class ServiceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? additionalActions;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ServiceAppBar({
    super.key,
    required this.title,

    this.additionalActions,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black87,
      elevation: elevation,
      leading: leading,
      actions: [

        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
