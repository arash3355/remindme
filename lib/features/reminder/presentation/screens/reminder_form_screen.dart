import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/signature.dart';
import '../../domain/entities/reminder.dart';
import '../../provider/reminder_provider.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.editingReminder});

  final Reminder? editingReminder;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime _dueDate = DateTime.now().add(const Duration(hours: 1));
  String _category = 'Study';
  String _repeat = 'Daily';

  bool get isEdit => widget.editingReminder != null;

  @override
  void initState() {
    super.initState();
    final r = widget.editingReminder;
    if (r != null) {
      _titleCtrl.text = r.title;
      _noteCtrl.text = r.note ?? '';
      _dueDate = r.dueDate;
      _category = r.category;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _dueDate,
    );
    if (date == null) return;

    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        _dueDate.hour,
        _dueDate.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (time == null) return;

    setState(() {
      _dueDate = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleCtrl.text.trim();
    final note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();

    if (isEdit) {
      await ref
          .read(remindersProvider.notifier)
          .updateReminder(
            id: widget.editingReminder!.id,
            title: title,
            note: note,
            dueDate: _dueDate,
            category: _category,
          );
    } else {
      await ref
          .read(remindersProvider.notifier)
          .addReminder(
            title: title,
            note: note,
            dueDate: _dueDate,
            category: _category,
          );
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MM/dd/yyyy').format(_dueDate);
    final timeText = DateFormat('HH:mm').format(_dueDate);

    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
        child: Column(
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
            const SizedBox(height: 18),
            Text(
              'Details Reminder',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textDark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _TextFieldBlock(label: 'Title', controller: _titleCtrl),
                    const SizedBox(height: 12),
                    _TextFieldBlock(
                      label: 'Body',
                      controller: _noteCtrl,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    _DropdownBlock(
                      label: 'Category',
                      value: _category,
                      items: const [
                        'Study',
                        'Work',
                        'Personal',
                        'Health',
                        'Finance',
                      ],
                      onChanged: (v) => setState(() => _category = v),
                      dotColor: _dotColor(_category),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),
            Text(
              'Timing',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textDark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                children: [
                  _PickerRow(
                    label: 'Due Date',
                    value: dateText,
                    icon: Icons.calendar_month,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  _PickerRow(
                    label: 'Time & Reminder',
                    value: timeText,
                    icon: Icons.circle,
                    iconSize: 14,
                    onTap: _pickTime,
                  ),
                  const SizedBox(height: 12),
                  _DropdownBlock(
                    label: 'Repeat Reminder',
                    value: _repeat,
                    items: const ['No Repeat', 'Daily', 'Monthly', 'Yearly'],
                    onChanged: (v) => setState(() => _repeat = v),
                    trailingIcon: Icons.repeat,
                  ),
                ],
              ),
            ),

            const Spacer(),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? 'Save Change' : 'Save',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Signature(),
          ],
        ),
      ),
    );
  }

  Color _dotColor(String category) {
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

/* ---------- UI Helpers ---------- */

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.55),
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );
}

class _TextFieldBlock extends StatelessWidget {
  const _TextFieldBlock({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: AppColors.textDark.withOpacity(0.75)),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
        ),
        validator: (v) => (label == 'Title' && (v == null || v.trim().isEmpty))
            ? 'Title wajib diisi'
            : null,
      ),
      const Divider(thickness: 1.2),
    ],
  );
}

class _DropdownBlock extends StatelessWidget {
  const _DropdownBlock({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.dotColor,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final Color? dotColor;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: AppColors.textDark.withOpacity(0.75)),
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          DropdownButton<String>(
            value: value,
            underline: const SizedBox.shrink(),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onChanged(v ?? value),
          ),
          if (dotColor != null) ...[
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
          const Spacer(),
          Icon(
            trailingIcon ?? Icons.arrow_drop_down,
            color: AppColors.textDark,
          ),
        ],
      ),
      const Divider(thickness: 1.2),
    ],
  );
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.iconSize = 20,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: AppColors.textDark.withOpacity(0.75)),
      ),
      const SizedBox(height: 6),
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
            const Spacer(),
            Icon(
              icon,
              size: iconSize,
              color: AppColors.textDark.withOpacity(0.8),
            ),
          ],
        ),
      ),
      const Divider(thickness: 1.2),
    ],
  );
}
