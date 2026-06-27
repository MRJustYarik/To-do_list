class Task {
  String id;
  String title;
  bool isDone;
  DateTime createdAt;
  int priority; // 1-ниский, 2-средний, 3-высокий

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
    this.priority = 2,
  }) : createdAt = createdAt ?? DateTime.now();

  //Для сохранения в json
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
    'priority': priority,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isDone: json['isDone'],
    createdAt: DateTime.parse(json['createAt']),
    priority: json['priority'],
  );
}
