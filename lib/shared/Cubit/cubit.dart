import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks/done%20screen.dart';
import 'package:to_do_app/modules/tasks/tasks%20screen.dart';
import 'package:to_do_app/shared/Cubit/states.dart';

class CubitApp extends Cubit<StatesApp> {
  List<Widget> screens = [
    tasksScreen(),
    doneScreen(),
    archivedScreen(),
  ];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  int current_index = 0;

  CubitApp() : super(initialState());

  static CubitApp get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    current_index = index;
    emit(ChangeButtonNavBar());
  }

  bool isbuttonSheetShown = false;
  IconData vabicon = Icons.edit;
  late Database database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE TASKS (ID INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT ,status TEXT)')
          .then((value) {
        print('creation is done');
      }).catchError((error) {
        print('creation error is ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database open');
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  InserttoDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert('INSERT INTO tasks(title,date,time,status)VALUES'
              '("$title","$date","$time","New")')
          .then((value) {
        emit(AppInsertDatabase());
        print('$value successfully');
        getDataFromDatabase(database);
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    database.rawQuery('SELECT * FROM TASKS').then((value) {
      //
      print (value);
      value.forEach((element) {
        if (element['status'] == 'New') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          print(element);
          donetasks.add(element);
        } else {
          archivedtasks.add(element);
          print(element);
        }
      });
      emit(AppGetDatabase());
    });
  }

  void ChangeButtonSheetState(
      {required bool isButtonSheet, required var Vabicon}) {
    isbuttonSheetShown = isButtonSheet;
    vabicon = Vabicon;
    emit(ChangeButtonSheetstate());
  }

  void UpdateData({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE TASKS SET status=? WHERE ID=?', ['$status', id]).then((value) {
          print(value);
      getDataFromDatabase(database);
      emit(AppUpdateDatabase());
    });
  }
  void DeleteData({ required int id}) async {
    //.rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    database.rawUpdate(
        'DELETE FROM TASKS WHERE ID = ?', [id,]).then((value) {
      print(value);
      getDataFromDatabase(database);
      emit(AppDeleteDatabase());
    });
  }
}
