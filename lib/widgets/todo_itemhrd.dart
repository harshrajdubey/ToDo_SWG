import '../../model/task.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';


class ToDoItemHRD extends StatelessWidget {
  final Task task;


   ToDoItemHRD({
    Key? key,
    required this.task,
  }) : super(key: key);

    final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // print('Clicked on Todo Item.');
_databaseService.deleteTask(
            task.tid,
            );        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          (task.status==1) ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: (task.status==1) ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
            _databaseService.deleteTask(
            task.tid,
            );
  Navigator.pop(context,);
            },
          ),
        ),
      ),
    );
  }
}