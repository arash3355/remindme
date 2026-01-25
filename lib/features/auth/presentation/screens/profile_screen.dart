import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../provider/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStream = ref.watch(authSessionProvider);

    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          child: authStream.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            data: (authState) {
              final session =
                  authState.session ??
                  Supabase.instance.client.auth.currentSession;
              final user = session?.user;

              return FutureBuilder<_ProfileInfo>(
                future: _loadProfileInfo(user),
                builder: (context, snap) {
                  final info =
                      snap.data ??
                      _ProfileInfo(
                        name:
                            user?.userMetadata?['username']?.toString() ??
                            user?.email?.split('@').first ??
                            'Guest User',
                        email: user?.email ?? 'Not logged in',
                      );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          '< Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black12,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    info.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    info.email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark.withOpacity(
                                        0.55,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _ManageButton(
                              onTap: () async {
                                final selected = await showMenu<String>(
                                  context: context,
                                  position: _menuPosition(context),
                                  items: [
                                    const PopupMenuItem(
                                      value: 'change',
                                      child: Text('Change Account'),
                                    ),
                                    PopupMenuItem(
                                      value: user == null
                                          ? 'signin'
                                          : 'signout',
                                      child: Text(
                                        user == null ? 'Sign In' : 'Sign Out',
                                        style: TextStyle(
                                          color: user == null
                                              ? AppColors.textDark
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                                if (selected == null) return;

                                if (selected == 'change') {
                                  if (context.mounted) context.push('/login');
                                  return;
                                }

                                if (selected == 'signin') {
                                  if (context.mounted) context.push('/login');
                                  return;
                                }

                                if (selected == 'signout') {
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .signOut();
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'Setting',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),

                      _SettingCard(
                        children: [
                          _SettingRow(
                            icon: Icons.notifications_none,
                            label: 'Notification',
                            trailing: Switch(
                              value: true,
                              activeColor: AppColors.primary,
                              onChanged: (_) {},
                            ),
                          ),
                          _divider(),
                          _SettingRow(
                            icon: Icons.volume_up_outlined,
                            label: 'Reminder Sound',
                            trailingText: 'Beep >',
                            onTap: () => context.push('/notification-sound'),
                          ),
                          _divider(),
                          _SettingRow(
                            icon: Icons.calendar_month_outlined,
                            label: 'Due Date Sound',
                            trailingText: 'Clank >',
                            onTap: () => context.push('/notification-sound'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),

                      _SettingCard(
                        children: [
                          const _SettingRow(
                            icon: Icons.info_outline,
                            label: 'App Version',
                            trailingText: '1.0.0',
                          ),
                          _divider(),
                          _SettingRow(
                            icon: Icons.privacy_tip_outlined,
                            label: 'Privacy Policy',
                            trailingIcon: Icons.open_in_new,
                            onTap: () async {
                              final Uri url = Uri.parse('..');
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          _divider(),
                          _SettingRow(
                            icon: Icons.description_outlined,
                            label: 'Terms and Conditions',
                            trailingIcon: Icons.open_in_new,
                            onTap: () async {
                              final Uri url = Uri.parse(
                                'https://www.example.com/terms-and-conditions',
                              );
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),

                      const Spacer(),
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/remindme_logo.png',
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'RemindMe',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textDark.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<_ProfileInfo> _loadProfileInfo(User? user) async {
    final email = user?.email ?? 'Not logged in';

    String? metaName = user?.userMetadata?['username']?.toString();
    metaName = (metaName == null || metaName.trim().isEmpty) ? null : metaName;

    if (user == null) {
      return _ProfileInfo(name: 'Guest User', email: email);
    }

    String? profileName;
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      profileName = res?['full_name']?.toString();
      if (profileName != null && profileName.trim().isEmpty) profileName = null;
    } catch (_) {}

    final name =
        metaName ?? profileName ?? user.email?.split('@').first ?? 'Guest User';

    return _ProfileInfo(name: name, email: email);
  }

  static RelativeRect _menuPosition(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return RelativeRect.fromSize(
      Rect.fromLTWH(overlay.size.width - 200, 110, 190, 160),
      overlay.size,
    );
  }

  static Widget _divider() =>
      Divider(height: 18, thickness: 1, color: Colors.black.withOpacity(0.05));
}

class _ProfileInfo {
  final String name;
  final String email;
  _ProfileInfo({required this.name, required this.email});
}

class _ManageButton extends StatelessWidget {
  const _ManageButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Manage Account',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.trailingText,
    this.trailingIcon,
    this.onTap,
  });

  final IconData icon;
  final String label;

  final Widget? trailing;
  final String? trailingText;
  final IconData? trailingIcon;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textDark.withOpacity(0.75)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (trailing != null) trailing!,
        if (trailingText != null)
          Text(
            trailingText!,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textDark.withOpacity(0.6),
            ),
          ),
        if (trailingIcon != null)
          Icon(
            trailingIcon!,
            size: 16,
            color: AppColors.textDark.withOpacity(0.65),
          ),
      ],
    );

    if (onTap == null) return row;
    return GestureDetector(onTap: onTap, child: row);
  }
}
