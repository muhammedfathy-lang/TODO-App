import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:to_do_app/shared/Cubit/cubit.dart';

Widget NoTasksColumn(){
  return
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(Icons.menu,
          color:Colors.grey ,
            size: 35,
          ),
          SizedBox(height: 10,),
          Text('No Thanks Yet, Please add some tasks',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),)
        ],),
      );
}
Widget BuildItemtask(Map model,context) {
  return Dismissible(
    key: Key(model['ID'].toString()),
    child: Container (
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}'
              , maxLines: 1,),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}'
                  , maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 5.0,),
                Text('${model['date']} ', style: TextStyle(
                    fontSize: 15,fontWeight: FontWeight.bold
                ),)
              ],
            ),
          ),
          IconButton(onPressed: (){
            CubitApp.get(context).UpdateData(status: 'done', id:model['ID']);
          },
              icon: Icon(
                  Icons.check_box,
                  color:Colors.green
              )),
          IconButton(onPressed: (){
            CubitApp.get(context).UpdateData(status: 'archived', id:model['ID']);
          },
              icon: Icon(
                  Icons.archive_outlined,
                  color:Colors.grey
              ))
        ],
      ),
    ),
    onDismissed:(direction) {
CubitApp.get(context).DeleteData(id: model['ID']);
    },
  );
}