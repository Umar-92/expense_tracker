import 'package:flutter/material.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
class AppColors {
  static const Color bg       = Color(0xFF060B18);   // deep obsidian
  static const Color surface  = Color(0xFF0F1729);   // dark card
  static const Color elevated = Color(0xFF182039);   // slightly lighter card
  static const Color border   = Color(0xFF1E2D50);   // subtle border

  static const Color primary  = Color(0xFF38BDF8);   // sky blue
  static const Color gold     = Color(0xFFFFB700);   // money / amounts
  static const Color success  = Color(0xFF22C55E);   // green
  static const Color error    = Color(0xFFFF5C5C);   // red

  static const Color textPrimary   = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint      = Color(0xFF3A4A6B);
}

// ─── Gradients ───────────────────────────────────────────────────────────────
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient hero = LinearGradient(
    colors: [Color(0xFF0F2050), Color(0xFF1A0C3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient card = LinearGradient(
    colors: [Color(0xFF0F1729), Color(0xFF111E36)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─── Category helpers ────────────────────────────────────────────────────────
Color categoryColor(String cat) {
  switch (cat) {
    case 'Food':          return const Color(0xFFFF6B6B);
    case 'Transport':     return const Color(0xFF38BDF8);
    case 'Shopping':      return const Color(0xFFA78BFA);
    case 'Bills':         return const Color(0xFFFFB700);
    case 'Health':        return const Color(0xFFFF6B9D);
    case 'Entertainment': return const Color(0xFF34D399);
    default:              return const Color(0xFF94A3B8);
  }
}

IconData categoryIcon(String cat) {
  switch (cat) {
    case 'Food':          return Icons.restaurant_rounded;
    case 'Transport':     return Icons.directions_car_rounded;
    case 'Shopping':      return Icons.shopping_bag_rounded;
    case 'Bills':         return Icons.receipt_long_rounded;
    case 'Health':        return Icons.favorite_rounded;
    case 'Entertainment': return Icons.movie_rounded;
    default:              return Icons.tag_rounded;
  }
}

// ─── Shared input decoration ─────────────────────────────────────────────────
InputDecoration appInputDecoration({
  required String label,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.elevated,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    errorStyle: const TextStyle(color: AppColors.error),
  );
}

// ─── Gradient button ─────────────────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppGradients.primary
              : const LinearGradient(
                  colors: [Color(0xFF1C2D45), Color(0xFF1C2D45)],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

// ─── Decorative background orbs ──────────────────────────────────────────────
class OrbBackground extends StatelessWidget {
  final Widget child;

  const OrbBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // bg fill
        Container(color: AppColors.bg),
        // top-left orb
        Positioned(
          top: -80,
          left: -80,
          child: _orb(200, AppColors.primary.withOpacity(0.12)),
        ),
        // top-right orb
        Positioned(
          top: 80,
          right: -60,
          child: _orb(160, const Color(0xFFA78BFA).withOpacity(0.10)),
        ),
        // bottom-right orb
        Positioned(
          bottom: -100,
          right: -80,
          child: _orb(240, AppColors.primary.withOpacity(0.08)),
        ),
        child,
      ],
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
