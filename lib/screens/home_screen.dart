import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();
  bool isAddingTask = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final loadedTodos = await StorageService.loadTodos();
    setState(() {
      todos = loadedTodos;
    });
  }

  void addTodo() {
    if (controller.text.isEmpty) return;
    setState(() {
      todos.add(Todo(title: controller.text));
      StorageService.saveTodos(todos);
      controller.clear();
      isAddingTask = false;
    });
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
      StorageService.saveTodos(todos);
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
      StorageService.saveTodos(todos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Todo App',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Input Section (shown conditionally)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isAddingTask ? 70 : 0,
            padding: EdgeInsets.all(isAddingTask ? 16.0 : 0),
            child: isAddingTask
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Add a new task...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[500],
                            ),
                          ),
                          onSubmitted: (_) => addTodo(),
                          autofocus: true,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: addTodo,
                        icon: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          // Todo List
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: TodoItem(
                                todo: todos[index],
                                onToggle: () => toggleTodo(index),
                                onDelete: () => deleteTodo(index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAddingTask = !isAddingTask;
            if (!isAddingTask) controller.clear();
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(isAddingTask ? Icons.close : Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No tasks yet!",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Tap the + button to add a new task.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}