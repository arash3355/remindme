import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/reminder.dart';

class ReminderRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Reminder>> fetchReminders({String? category}) async {
    final res = category == null
        ? await _client
              .from('reminders')
              .select()
              .order('due_date', ascending: true)
        : await _client
              .from('reminders')
              .select()
              .eq('category', category)
              .order('due_date', ascending: true);

    return (res as List)
        .map((e) => Reminder.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> createReminder({
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) async {
    await _client.from('reminders').insert({
      'title': title,
      'note': note,
      'due_date': dueDate.toIso8601String(),
      'category': category,
      'is_done': false,
    });
  }

  Future<void> updateReminder({
    required String id,
    required String title,
    String? note,
    required DateTime dueDate,
    required String category,
  }) async {
    await _client
        .from('reminders')
        .update({
          'title': title,
          'note': note,
          'due_date': dueDate.toIso8601String(),
          'category': category,
        })
        .eq('id', id);
  }

  Future<void> markDone({required String id, required bool done}) async {
    await _client.from('reminders').update({'is_done': done}).eq('id', id);
  }

  Future<void> deleteReminder({required String id}) async {
    await _client.from('reminders').delete().eq('id', id);
  }
}
