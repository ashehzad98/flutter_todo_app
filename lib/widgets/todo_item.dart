import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: todo.isDone ? Theme.of(context).primaryColor : Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: todo.isDone
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        title: Text(
          todo.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey[600] : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}