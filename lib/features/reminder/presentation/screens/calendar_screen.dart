import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:remindme/features/reminder/presentation/widgets/task_card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/reminder.dart';
import '../../provider/reminder_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Color _categoryDotColor(List<Reminder> reminders) {
    if (reminders.isEmpty) return AppColors.purple;

    final category = reminders.first.category.toLowerCase();

    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(remindersProvider);

    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'RemindMe',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: async.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (items) {
                    final byDate = <DateTime, List<Reminder>>{};
                    for (final r in items) {
                      final key = DateTime(
                        r.dueDate.year,
                        r.dueDate.month,
                        r.dueDate.day,
                      );
                      byDate.putIfAbsent(key, () => []).add(r);
                    }

                    final selectedKey = _selectedDay == null
                        ? DateTime(
                            _focusedDay.year,
                            _focusedDay.month,
                            _focusedDay.day,
                          )
                        : DateTime(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                          );

                    final selectedItems = byDate[selectedKey] ?? [];

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2035, 12, 31),
                            focusedDay: _focusedDay,

                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),

                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },

                            headerStyle: HeaderStyle(
                              titleCentered: true,
                              formatButtonVisible: false,
                              leftChevronIcon: const Icon(
                                BootstrapIcons.chevron_left,
                                size: 18,
                                color: AppColors.textDark,
                              ),
                              rightChevronIcon: const Icon(
                                BootstrapIcons.chevron_right,
                                size: 18,
                                color: AppColors.textDark,
                              ),
                              titleTextStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),

                            calendarStyle: const CalendarStyle(
                              outsideDaysVisible: false,
                              todayDecoration: BoxDecoration(
                                color: Color(0xFFBFDFFF),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFF9B8CFF),
                                shape: BoxShape.circle,
                              ),
                            ),

                            eventLoader: (day) =>
                                byDate[DateTime(
                                  day.year,
                                  day.month,
                                  day.day,
                                )] ??
                                const [],

                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, day, events) {
                                if (events.isEmpty) return null;
                                return Positioned(
                                  left: 6,
                                  bottom: 6,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: BoxDecoration(
                                      color: _categoryDotColor(
                                        events.cast<Reminder>(),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'My Task',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w200,
                              color: AppColors.textDark.withOpacity(0.95),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: selectedItems.isEmpty
                              ? Center(
                                  child: Opacity(
                                    opacity: 0.55,
                                    child: Text(
                                      'No reminder on this date',
                                      style: TextStyle(
                                        color: AppColors.textDark.withOpacity(
                                          0.85,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: selectedItems.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, i) {
                                    final r = selectedItems[i];
                                    final timeText =
                                        '${DateFormat('MMMM dd - HH:mm').format(r.dueDate)} WIB';

                                    return TaskCard(
                                      reminder: r,
                                      borderColor: _borderByCategory(
                                        r.category,
                                      ),
                                      timeText: timeText,

                                      readOnly: true, // ✅ KUNCI UTAMA

                                      onTap: null,
                                      onToggleDone: null,
                                      onDelete: null,
                                    );
                                  },
                                ),
                        ),

                        const Signature(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
