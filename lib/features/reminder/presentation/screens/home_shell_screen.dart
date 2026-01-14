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
        height: 78,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 36),
          color: AppColors.navy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(icon: Icons.task_alt, label: 'Task', selected: index == 0, onTap: () => context.go('/tasks')),
              const SizedBox(width: 70),
              _NavItem(icon: Icons.calendar_month, label: 'Calender', selected: index == 1, onTap: () => context.go('/calendar')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add, size: 34, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? AppColors.primary : Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: selected ? AppColors.primary : Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
