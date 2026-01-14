import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/reminder_remote_datasource.dart';
import '../data/repositories/reminder_repository_impl.dart';
import '../domain/entities/reminder.dart';
import '../domain/repositories/reminder_repository.dart';

part 'reminder_provider.g.dart';

@riverpod
ReminderRepository reminderRepository(Ref ref) {
  return ReminderRepositoryImpl(ReminderRemoteDataSource());
}

@riverpod
class Reminders extends _$Reminders {
  String _category = 'Show All';

  @override
  Future<List<Reminder>> build() async {
    final repo = ref.read(reminderRepositoryProvider);
    return repo.fetchReminders(
      category: _category == 'Show All' ? null : _category,
    );
  }

  Future<void> setCategory(String category) async {
    _category = category;
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(reminderRepositoryProvider);
      return repo.fetchReminders(
        category: _category == 'Show All' ? null : _category,
      );
    });
  }

  Future<void> addReminder({
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) async {
    final repo = ref.read(reminderRepositoryProvider);
    await repo.createReminder(
      title: title,
      note: note,
      dueDate: dueDate,
      category: category,
    );
    await refresh();
  }

  Future<void> updateReminder({
    required String id,
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) async {
    final repo = ref.read(reminderRepositoryProvider);
    await repo.updateReminder(
      id: id,
      title: title,
      note: note,
      dueDate: dueDate,
      category: category,
    );
    await refresh();
  }

  Future<void> toggleDone(Reminder reminder) async {
    final repo = ref.read(reminderRepositoryProvider);
    await repo.markDone(id: reminder.id, done: !reminder.isDone);
    await refresh();
  }

  Future<void> delete(Reminder reminder) async {
    final repo = ref.read(reminderRepositoryProvider);
    await repo.deleteReminder(id: reminder.id);
    await refresh();
  }
}
