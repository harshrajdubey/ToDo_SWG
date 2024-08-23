import '../model/task.dart';
import '../colors/colors.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    int _selectedTab = 0;

  String statustofetch='0';  
  String appBarTitle = "My Tasks";

  final DatabaseService _databaseService = DatabaseService.instance;
    String? _task = null;
    String? _taskTitle = null;
    String? _taskDesc = null;
    String? _taskDeadline = null;
    int _priority=5000;

  String addDate = new DateTime.now().toString();


  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _changeTab(int index) {

if(index==3){

showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('SWG ToDo List App',textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Developed by Harsh Raj Dubey (24MF10006) for Student Welfare Group, IIT Kharagpur.\nApp Version: 10.01.01',
                textAlign: TextAlign.justify,
style: TextStyle(
                      color: tdBlue,
                      fontSize: 18,
                      
                    ),
                    ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "BACK",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );


}else{

    setState(() {
      _selectedTab = index;

      if(index==0){
   statustofetch='';  
   appBarTitle = "My Tasks";
      }
      if(index==2){
   statustofetch='1';  
   appBarTitle = "Completed Tasks";
      }
      if(index==1){
   statustofetch='0';  
   appBarTitle = "Pending Tasks";
      }
      
    });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            floatingActionButton: _addTaskButton(),

      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: _tasksList(),
            bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.grid_3x3_outlined), label: "My Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.check_box_outline_blank), label: "Pending Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), label: "Completed Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: "Dev Info"),
        ],
      ),

    );
  }


  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _taskTitle = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Title...',
                  ),
                ),
                                TextField(
                  onChanged: (value) {
                    setState(() {
                      _taskDesc = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Description...',
                  ),
                ),
                  TextField(
                    onChanged: (value) {
                    setState(() {
                      _priority = int.parse(value);
                    });
                  },

                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Deadline...',
                  ),
                ),
                                TextField(
                  onChanged: (value) {
                    setState(() {
                      _taskDeadline = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Priority...',
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if ( _taskTitle == null || _taskTitle == "" || _taskDesc == null || _taskDesc == "" || _taskDeadline == null || _priority == null || _priority == "") return;
                    _databaseService.addTask(_taskTitle!,_taskDesc!,_priority,addDate,_taskDeadline!);
                    setState(() {
                          _task = null;
    _taskTitle = null;
    _taskDesc = null;
    _taskDeadline = null;
    _priority = 5000;

                    });
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBlue,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
       
        Text('$appBarTitle - ToDo List',
        textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    )),
        Container(
          alignment: Alignment(55,0),
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/swglogo.png'),
          ),
        ),
      ]),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTasks(statustofetch),
      builder: (context, snapshot) {
        print(snapshot);
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task = snapshot.data![index];
            return Container(
      margin: const EdgeInsets.only(top: 20,left: 10,right: 10),
      child: ListTile(
                      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          Icons.insert_chart_outlined_outlined,
          color: tdBlue,
        ),

              onLongPress: () {
showAlertDialog(context,task);
              },
              onTap: () {
_taskTitle=task.title;
_taskDesc=task.desc;
_taskDeadline=task.deadline;
_priority=task.pri;

showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Edit Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: TextEditingController()..text = task.title,
                    onChanged: (value) {
                    setState(() {
                      _taskTitle = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Title...',
                  ),
                ),
                                TextField(
                    controller: TextEditingController()..text = task.desc,
                    onChanged: (value) {
                    setState(() {
                      _taskDesc = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Description...',
                  ),
                ),
                                TextField(
                    controller: TextEditingController()..text = task.deadline,
                    onChanged: (value) {
                    setState(() {
                      _taskDeadline = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Deadline...',
                  ),
                ),
                                TextField(
                    controller: TextEditingController()..text = task.pri.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                    setState(() {
                      if(value!=''){
                      _priority = int.parse(value);
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))                    ),
                    hintText: 'Priority...',
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if ( _taskTitle == null || _taskTitle == "" || _taskDesc == null || _taskDesc == "" || _taskDeadline == null || _taskDeadline == "" || _priority == null || _priority == "") return;
                    _databaseService.editTask(task.tid,_taskTitle!,_taskDesc!,_priority,_taskDeadline!);
                    setState(() {
                          _task = null;
    _taskTitle = null;
    _taskDesc = null;
    _taskDeadline = null;
    _priority = 5000;

                    });
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
              },
              title: Text(
                task.title,
                                                              style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: (task.status==1) ? TextDecoration.lineThrough : null,
                ),

              ),

              trailing:  Checkbox(
                value: task.status == 1,
                onChanged: (value) {
                  _databaseService.updateTaskStatus(
                    task.tid,
                    value == true ? 1 : 0,
                  );
                  setState(() {});
                },
              ),
            ));
          },
        );
      },
    );
  }

  showAlertDialog(BuildContext context,task) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: (){
                    Navigator.pop(
                      context,
                    );

    },
  );
  Widget continueButton = TextButton(
    child: Text("Delete"),
    onPressed: (){
            _databaseService.deleteTask(
            task.tid,
            );
            setState(() {});
                                Navigator.pop(
                      context,
                    );

    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Would you like to delete the task with the title '"+task.title+"' ? This cannot be undone."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

}
