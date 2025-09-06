class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });

  // Convert Todo to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };

  // Create Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        isDone: json['isDone'],
      );
}