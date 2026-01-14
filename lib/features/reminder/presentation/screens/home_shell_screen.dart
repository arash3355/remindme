import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key, required this.child});
  final Widget child;

  int _indexFromLocation(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/calendar')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexFromLocation(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: child,

      bottomNavigationBar: SizedBox(
        height: 82,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(color: AppColors.navy),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.task_alt,
                  label: 'Task',
                  selected: index == 0,
                  onTap: () => context.go('/tasks'),
                ),
              ),

              const SizedBox(width: 78),

              Expanded(
                child: _NavItem(
                  icon: Icons.calendar_month,
                  label: 'Calendar',
                  selected: index == 1,
                  onTap: () => context.go('/calendar'),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          elevation: 6,
          onPressed: () => context.push('/create'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : Colors.white;

    return InkWell(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
