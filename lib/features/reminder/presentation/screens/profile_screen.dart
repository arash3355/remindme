import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/signature.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notif = true;
  String reminderSound = 'Beep';
  String dueDateSound = 'Clank';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(onTap: () => context.pop(), child: const Text('< Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark))),
            const SizedBox(height: 18),
            Row(
              children: [
                const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Guest User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    Text('guest@remindme.app', style: TextStyle(color: AppColors.textDark.withOpacity(0.7))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            _tileSwitch('Notification', notif, (v) => setState(() => notif = v)),
            _tileDropdown('Reminder Sound', reminderSound, ['Beep', 'Clank', 'Chirp'], (v) => setState(() => reminderSound = v)),
            _tileDropdown('Due Date Sound', dueDateSound, ['Clank', 'Beep', 'Flute'], (v) => setState(() => dueDateSound = v)),
            const SizedBox(height: 12),
            const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 8),
            _tileNav('Privacy Policy', () {}),
            _tileNav('Terms and Conditions', () {}),
            const Spacer(),
            const Signature(),
          ],
        ),
      ),
    );
  }

  Widget _tileSwitch(String title, bool value, ValueChanged<bool> onChanged) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(14)),
        child: SwitchListTile(title: Text(title, style: const TextStyle(color: AppColors.textDark)), value: value, onChanged: onChanged),
      );

  Widget _tileDropdown(String title, String value, List<String> items, ValueChanged<String> onChanged) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(color: AppColors.textDark))),
            DropdownButton<String>(
              value: value,
              underline: const SizedBox.shrink(),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => onChanged(v ?? value),
            ),
          ],
        ),
      );

  Widget _tileNav(String title, VoidCallback onTap) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(14)),
        child: ListTile(title: Text(title, style: const TextStyle(color: AppColors.textDark)), trailing: const Icon(Icons.chevron_right), onTap: onTap),
      );
}
