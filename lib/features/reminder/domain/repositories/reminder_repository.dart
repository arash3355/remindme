import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> fetchReminders({String? category});

  Future<void> createReminder({
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  });

  Future<void> markDone({required String id, required bool done});

  Future<void> updateReminder({
    required String id,
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) async {}

  Future<void> deleteReminder({required String id}) async {}
}
