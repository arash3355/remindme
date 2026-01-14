import 'package:remindme/features/reminder/domain/repositories/reminder_repository.dart';

import '../../domain/entities/reminder.dart';
import '../datasources/reminder_remote_datasource.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this.remote);

  final ReminderRemoteDataSource remote;

  @override
  Future<List<Reminder>> fetchReminders({String? category}) {
    return remote.fetchReminders(category: category);
  }

  @override
  Future<void> createReminder({
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) {
    return remote.createReminder(
      title: title,
      note: note,
      dueDate: dueDate,
      category: category,
    );
  }

  @override
  Future<void> updateReminder({
    required String id,
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) {
    return remote.updateReminder(
      id: id,
      title: title,
      note: note,
      dueDate: dueDate,
      category: category,
    );
  }

  @override
  Future<void> markDone({required String id, required bool done}) {
    return remote.markDone(id: id, done: done);
  }

  @override
  Future<void> deleteReminder({required String id}) {
    return remote.deleteReminder(id: id);
  }
}
