import 'package:flutter/material.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    //if this is the first time ever openingthe app,then create default data
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      //there already exists data
      db.loadData();
    }

    super.initState();
  }

  //text controller
  final _controller = TextEditingController();
  //List of todo tasks

  // List toDoList = [
  //   ['Tutorial', false],
  //   ['Do Exercise', false],
  // ];

  // get index => null;

//checkboxed was tapped

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

//save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

//create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(
            child: Text(
          'TO DO',
          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.892)),
        )),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
        // children: [
        //   ToDoTile(
        //     taskName: 'Tutorial',
        //     taskCompleted: true,
        //     onChanged: (P0) {},
        //   ),
        //   ToDoTile(
        //     taskName: 'Do Exercise',
        //     taskCompleted: false,
        //     onChanged: (P0) {},
        //   ),
        //   ToDoTile(
        //     taskName: 'Tutorial',
        //     taskCompleted: true,
        //     onChanged: (P0) {},
        //   ),
        // ],
      ),
    );
  }
}
