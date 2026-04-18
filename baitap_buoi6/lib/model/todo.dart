class Todo {
  final int? id;
  final String title;
  final String content;
  int isDone; // 0: Chưa hoàn thành, 1: Hoàn thành

  Todo({this.id, required this.title, required this.content, this.isDone = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content, 'isDone': isDone};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isDone: map['isDone'] ?? 0,
    );
  }
}
