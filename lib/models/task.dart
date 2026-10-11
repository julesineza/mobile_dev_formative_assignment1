class Task {
  final String id;
  final String name;
  final String description;
  final DateTime deadline;
  final String priority;
  final String status;
  final List<String> assignees;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.assignees,
    this.completedAt,
  });

  Task copyWith({
    String? name,
    String? description,
    DateTime? deadline,
    String? priority,
    String? status,
    List<String>? assignees,
    DateTime? completedAt,
  }) {
    return Task(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignees: assignees ?? this.assignees,
      completedAt: (status ?? this.status) == 'Done'
          ? completedAt ?? this.completedAt
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'priority': priority,
    'status': status,
    'assignees': assignees,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: json['priority'] as String,
      status: json['status'] as String,
      assignees: List<String>.from(json['assignees'] as List<dynamic>),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }
}
