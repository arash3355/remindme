import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reminder.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.reminder,
    required this.borderColor,
    required this.timeText,
    this.onTap,
    this.onToggleDone,
    this.onDelete,
    this.readOnly = false,
  });

  final Reminder reminder;
  final Color borderColor;
  final String timeText;
  final bool readOnly;
  final dynamic onTap;
  final dynamic onToggleDone;
  final dynamic onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.88),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: readOnly ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: readOnly ? null : onToggleDone,

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
                  child: readOnly
                      ? null
                      : reminder.isDone
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
