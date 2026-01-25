import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/reminder.dart';
import '../../provider/reminder_provider.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({
    super.key,
    required this.onCreate,
    required this.onOpenDetail,
  });

  final Future<Object?> Function() onCreate;
  final Future<Object?> Function(Reminder) onOpenDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(remindersProvider);

    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'RemindMe',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/profile'),
                  icon: const Icon(BootstrapIcons.person_circle, size: 34),
                  color: AppColors.textDark,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Scheduled',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),

                PopupMenuButton<String>(
                  onSelected: (v) =>
                      ref.read(remindersProvider.notifier).setCategory(v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Show All', child: Text('Show All')),
                    PopupMenuItem(value: 'Study', child: Text('Study')),
                    PopupMenuItem(value: 'Work', child: Text('Work')),
                    PopupMenuItem(value: 'Personal', child: Text('Personal')),
                    PopupMenuItem(value: 'Health', child: Text('Health')),
                    PopupMenuItem(value: 'Finance', child: Text('Finance')),
                  ],
                  child: Row(
                    children: [
                      Text(
                        'Short By =',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _Dot(color: AppColors.purple),
                      const _Dot(color: AppColors.blue),
                      const _Dot(color: AppColors.red),
                      const _Dot(color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Opacity(
                        opacity: 0.55,
                        child: Text(
                          'Create your first reminder',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textDark.withOpacity(0.85),
                          ),
                        ),
                      ),
                    );
                  }

                  final activeTasks = items.where((e) => !e.isDone).toList()
                    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                  final completedTasks = items.where((e) => e.isDone).toList()
                    ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 90),
                    children: [
                      if (activeTasks.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Upcoming Task',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark.withOpacity(0.65),
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...activeTasks.map((r) {
                          final timeText =
                              '${DateFormat('MMMM dd - HH:mm').format(r.dueDate)} WIB';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _TaskCard(
                              reminder: r,
                              borderColor: _borderByCategory(r.category),
                              timeText: timeText,
                              onTap: () => context.push('/edit', extra: r),
                              onToggleDone: () => ref
                                  .read(remindersProvider.notifier)
                                  .toggleDone(r),
                              onDelete: () => ref
                                  .read(remindersProvider.notifier)
                                  .delete(r),
                            ),
                          );
                        }),
                      ],

                      if (completedTasks.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text(
                          'Completed Task',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark.withOpacity(0.45),
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...completedTasks.map((r) {
                          final timeText =
                              '${DateFormat('MMMM dd - HH:mm').format(r.dueDate)} WIB';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Opacity(
                              opacity: 0.55,
                              child: _TaskCard(
                                reminder: r,
                                borderColor: _borderByCategory(r.category),
                                timeText: timeText,
                                onTap: () => context.push('/edit', extra: r),
                                onToggleDone: () => ref
                                    .read(remindersProvider.notifier)
                                    .toggleDone(r),
                                onDelete: () => ref
                                    .read(remindersProvider.notifier)
                                    .delete(r),
                              ),
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: 10),
                      const Signature(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _borderByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'study':
        return AppColors.purple;
      case 'work':
        return AppColors.blue;
      case 'health':
        return AppColors.red;
      case 'personal':
        return Colors.green;
      case 'finance':
        return Colors.orange;
      default:
        return AppColors.purple;
    }
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.reminder,
    required this.borderColor,
    required this.timeText,
    required this.onTap,
    required this.onToggleDone,
    required this.onDelete,
  });

  final Reminder reminder;
  final Color borderColor;
  final String timeText;
  final VoidCallback onTap;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.88),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onToggleDone,
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                    color: reminder.isDone
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  child: reminder.isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        decoration: reminder.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if ((reminder.note ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        reminder.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark.withOpacity(0.7),
                          decoration: reminder.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      timeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: borderColor,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 4,
                height: 46,
                margin: const EdgeInsets.only(left: 10, top: 6),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
