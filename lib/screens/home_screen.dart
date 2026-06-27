import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  String _filter = 'all'; // all, done, undone
  String _sortBy = 'date'; // date, priority

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список дел'),
        actions: [
          // Кнопка сортировки
          PopupMenuButton(
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'date', child: Text('По дате')),
              PopupMenuItem(value: 'priority', child: Text('По важности')),
            ],
          ),
          // Кнопка фильтрации
          PopupMenuButton(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('Все')),
              PopupMenuItem(value: 'done', child: Text('Выполненные')),
              PopupMenuItem(value: 'undone', child: Text('Невыполненные')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _getFilteredAndSortedTasks().length,
        itemBuilder: (context, index) {
          final task = _getFilteredAndSortedTasks()[index];
          return TaskItem(
            task: task,
            onToggle: () => _toggleTask(task),
            onEdit: () => _editTask(task),
            onDelete: () => _deleteTask(task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }

  // Фильтрация и сортировка
  List<Task> _getFilteredAndSortedTasks() {
    var filtered = tasks.where((task) {
      if (_filter == 'done') return task.isDone;
      if (_filter == 'undone') return !task.isDone;
      return true;
    }).toList();

    if (_sortBy == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'priority') {
      filtered.sort((a, b) => b.priority.compareTo(a.priority));
    }

    return filtered;
  }

  // Добавление задачи
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (title, priority) {
          setState(() {
            tasks.add(
              Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                priority: priority,
              ),
            );
          });
        },
      ),
    );
  }

  // Отметка выполненной
  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  // Удаление
  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  // Редактирование
  void _editTask(Task task) {
    // Можно использовать тот же диалог, но с заполненными полями
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        initialTitle: task.title,
        initialPriority: task.priority,
        onAdd: (newTitle, newPriority) {
          setState(() {
            task.title = newTitle;
            task.priority = newPriority;
          });
        },
      ),
    );
  }
}
