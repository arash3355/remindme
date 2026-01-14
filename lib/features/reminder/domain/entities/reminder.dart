class Reminder {
  Reminder({
    required this.id,
    required this.title,
    this.note,
    required this.dueDate,
    required this.category,
    required this.isDone,
  });

  final String id;
  final String title;
  final String? note;
  final DateTime dueDate;
  final String category;
  final bool isDone;

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'].toString(),
        title: json['title'] as String,
        note: json['note'] as String?,
        dueDate: DateTime.parse(json['due_date'] as String),
        category: (json['category'] as String?) ?? 'Study',
        isDone: (json['is_done'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'due_date': dueDate.toIso8601String(),
        'category': category,
        'is_done': isDone,
      };
}
