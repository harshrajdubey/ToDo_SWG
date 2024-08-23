import 'dart:ffi';
import '../model/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  
  static String taskTable="task_hrd";
  static String taskTableId="tid";
  static String taskTableTitle="title";
  static String taskTableDescription="desc";
  static String taskTablePriority="pri";
  static String taskTableAddDate="addDate";
  static String taskTableDeadlineDate="deadline";
  static String taskTableStatus="status";

  String requestStatus="";
  List ddata=[];

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {

    final databaseDirPath=await getDatabasesPath();
    final databasePath=join(databaseDirPath,"hrdtodo.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db,version){
        try{
        db.execute("""
CREATE TABLE $taskTable (
$taskTableId INTEGER PRIMARY KEY,
$taskTableTitle TEXT NOT NULL,
$taskTableDescription TEXT NOT NULL,
$taskTablePriority INTEGER,
$taskTableAddDate TEXT NOT NULL,
$taskTableDeadlineDate TEXT NOT NULL,
$taskTableStatus INTEGER

);

""");

print('dbcreate');
  } on DatabaseException catch (e) {
  // Log the error: print(e);
  // Show the user a message: 
print(e);
}

      }
      );
      return database;

  }

  void addTask(
    String title,String desc,int pri,String addDate,String deadline,
  ) async {
    final db = await database;
    await db.insert(
      taskTable,
      {
        taskTableTitle: title,
        taskTableDescription: desc,
        taskTablePriority: pri,
        taskTableAddDate: addDate,
        taskTableDeadlineDate: deadline,
        taskTableStatus: 0,
      },
    );

    try {

    await db.insert(
      taskTable,
      {
        taskTableTitle: title,
        taskTableDescription: desc,
        taskTablePriority: pri,
        taskTableAddDate: addDate,
        taskTableDeadlineDate: deadline,
        taskTableStatus: 0,
      },
    );
    } on DatabaseException catch (e) {
  // Log the error: print(e);
  // Show the user a message: 
print(e);
}

  }

  void editTask(
    int tid, String title,String desc,int pri,String deadline,
  ) async {
    final db = await database;

    try {
 await db.update(
      taskTable,
      {
        taskTableTitle: title,
        taskTableDescription: desc,
        taskTablePriority: pri,
        taskTableDeadlineDate: deadline
        },
              where: 'tid = ?',
      whereArgs: [
        tid,
      ],

    );

    } on DatabaseException catch (e) {
  // Log the error: print(e);
  // Show the user a message: 
print(e);
}

  }

  Future<List<Task>> getTasks(String statusvar) async {
    final db = await database;
    requestStatus=statusvar;
    if(requestStatus!=""){
    ddata = await db.rawQuery('SELECT * FROM $taskTable WHERE $taskTableStatus=? ORDER BY status ASC, pri ASC,tid ASC', [requestStatus]);
    }else{
    ddata = await db.rawQuery('SELECT * FROM $taskTable ORDER BY status ASC, pri ASC,tid ASC');
    }

requestStatus="";

    final data=ddata;
    List<Task> tasks = data
        .map(
          (e) => Task(
            tid: e["tid"] as int,
            status: e["status"] as int,
            title: e["title"] as String,
            desc: e["desc"] as String,
            addDate: e["addDate"] as String,
            deadline: e["deadline"] as String,
            pri: e["pri"] as int,
          ),
        )
        .toList();
        
    return tasks;
  }

  void updateTaskStatus(int tid, int status) async {
    final db = await database;
    await db.update(
      taskTable,
      {
        taskTableStatus: status,
      },
      where: 'tid = ?',
      whereArgs: [
        tid,
      ],
    );
  }

  void deleteTask(
    int tid,
  ) async {
    final db = await database;
    await db.delete(
      taskTable,
      where: 'tid = ?',
      whereArgs: [
        tid,
      ],
    );
  }
}
