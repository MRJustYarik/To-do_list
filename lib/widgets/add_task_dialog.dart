import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, int) onAdd;
  final String? initialTitle;
  final int? initialPriority;

  const AddTaskDialog({
    required this.onAdd,
    this.initialTitle,
    this.initialPriority,
  });

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  int _priority = 2;

  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null) {
      _controller.text = widget.initialTitle!;
    }
    if (widget.initialPriority != null) {
      _priority = widget.initialPriority!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialTitle == null ? 'Новая задача' : 'Редактировать',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Введите задачу'),
            autofocus: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Важность:'),
              Expanded(
                child: Slider(
                  value: _priority.toDouble(),
                  min: 1,
                  max: 3,
                  divisions: 2,
                  label: _priority == 1
                      ? 'Низкая'
                      : _priority == 2
                      ? 'Средняя'
                      : 'Высокая',
                  onChanged: (value) =>
                      setState(() => _priority = value.toInt()),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text, _priority);
              Navigator.pop(context);
            }
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}
