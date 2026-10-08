class Task {
  final String id;
  final String name;
  final String description;
  final DateTime deadline;
  final String priority;
  final String status;
  final List<String> assignees;

  const Task({
    required this.id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.assignees,
  });

  Task copyWith({
    String? name,
    String? description,
    DateTime? deadline,
    String? priority,
    String? status,
    List<String>? assignees,
  }) {
    return Task(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignees: assignees ?? this.assignees,
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
    );
  }
}
