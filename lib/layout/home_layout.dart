import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/Cubit/cubit.dart';
import 'package:to_do_app/shared/Cubit/states.dart';

class home_layout extends StatelessWidget {



  var taskcontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var statuscontroller = TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formdkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      CubitApp()..createDatabase(),
      child: BlocConsumer<CubitApp, StatesApp>(
        listener: (context, state) {
          if(state is AppInsertDatabase){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          CubitApp Cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                  Cubit.titles[Cubit.current_index],
                  style: TextStyle(
                      fontSize: 20
                  )
              ),
            ),
            body: Cubit.screens[Cubit.current_index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: Cubit.current_index,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                Cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon:
                Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(icon:
                Icon(Icons.check_circle_outline),
                    label: 'Done'
                ),
                BottomNavigationBarItem(icon:
                Icon(Icons.archive_outlined),
                    label: 'Archived '
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {
             if(Cubit.isbuttonSheetShown){
               if(formdkey.currentState!.validate()){
                 Cubit.InserttoDatabase(title: taskcontroller.text, time: timecontroller.text, date: datecontroller.text);
                 Cubit.ChangeButtonSheetState(Vabicon: Icons.edit, isButtonSheet:false);
               }
                 }
             else{
               scaffoldkey.currentState!.showBottomSheet((context) =>
                   Container(
                     color: Colors.white,
                     padding: EdgeInsets.all(20.0),
                     child: Form(
                      key: formdkey,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           TextFormField(
                             controller: taskcontroller,
                             decoration: InputDecoration(
                               labelText: 'Task Title',
                               border: OutlineInputBorder(),
                               prefixIcon: Icon(Icons.title),
                             ),
                             validator: (value){
                               if(value!.isEmpty) {
                                 return 'title must not be empty';
                               }
                             },
                           ),
                           SizedBox(height: 15,),
                           TextFormField(
                             controller: timecontroller,
                             keyboardType: TextInputType.datetime,
                             decoration: InputDecoration(
                               border: OutlineInputBorder(),
                               prefixIcon: Icon(Icons.watch_later_outlined),
                               labelText: 'Task Time',
                             ),
                             validator:(value) {
                               if (value!.isEmpty){
                                 return 'time must not be empty';
                               }
                             },
                               onTap: (){
                               showTimePicker(context: context,
                                   initialTime: TimeOfDay.now()).then((value) => {
                                     timecontroller.text=value!.format(context)
                               });
                               },

                           ),
                           SizedBox(height: 15,),
                           TextFormField(
                             controller: datecontroller,
                             decoration: InputDecoration(
                               border: OutlineInputBorder(),
                               prefixIcon: Icon(Icons.calendar_today),
                               labelText: 'Task Date',
                             ),
                             validator:(value) {
                               if (value!.isEmpty){
                                 return 'date must not be empty';
                               }
                             },
                             onTap: (){
                               showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                   firstDate: DateTime.now(),
                                   lastDate: DateTime.parse('2021-12-31')).then((value) => {
                                 datecontroller.text=DateFormat().add_yMMMd().format(value!)
                               });
                             },

                           ),
                         ],
                       ),
                     ),
                   ),
               elevation: 20.0).closed.then((value) {

                 Cubit.ChangeButtonSheetState(Vabicon: Icons.edit, isButtonSheet:false);
               });
               Cubit.ChangeButtonSheetState(Vabicon: Icons.add, isButtonSheet:true);
             }
            },
              child: Icon(Cubit.vabicon),

            ),
          );
        },
      ),
    );

  }

}

