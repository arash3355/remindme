import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/reminder.dart';
import '../../provider/reminder_provider.dart';
import '../widgets/task_card.dart';

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
                            child: TaskCard(
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
                              child: TaskCard(
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
