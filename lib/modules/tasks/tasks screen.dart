import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/component/Component.dart';
import 'package:to_do_app/shared/Cubit/cubit.dart';
import 'package:to_do_app/shared/Cubit/states.dart';

class tasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StatesApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = CubitApp
              .get(context)
              .newtasks;
          if (tasks.length == 0) {
            return NoTasksColumn();
          }
          else
            return ListView.separated(itemBuilder: (context, index) =>
                BuildItemtask(tasks[index], context)
                , separatorBuilder: (context, index) =>
                    Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      height: 1,
                    ),
                itemCount: tasks.length);
        });
  }
}