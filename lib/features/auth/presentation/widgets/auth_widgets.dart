import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthGlassCard extends StatelessWidget {
  const AuthGlassCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textDark.withOpacity(0.55), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hint,
                  isDense: true,
                  hintStyle: TextStyle(
                    color: AppColors.textDark.withOpacity(0.35),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
          ],
        ),
        const Divider(thickness: 1.2),
      ],
    );
  }
}

class PrimaryWideButton extends StatelessWidget {
  const PrimaryWideButton({
    super.key,
    required this.label,
    required this.onTap,
  });
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
