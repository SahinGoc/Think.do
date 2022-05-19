import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  late String title;
  late String? description;
  late String category;
  late String? date;
  late String? time;
  late String? rememberTime;
  late String? createTime;
  late String complete;
  late String archive;

  Todo(String title, String description, String category, String date, String time, String rememberTime, String createTime, String complete, String archive){
    this.title = title;
    this.description = description;
    this.category = category;
    this.date = date;
    this.time = time;
    this.rememberTime = rememberTime;
    this.createTime = createTime;
    this.complete = complete;
    this.archive = archive;
  }

  Todo.fromMap(Map<String,dynamic> map):
     assert(map["title"] != null){
      title = map["title"];
      description = map["description"];
      category = map["category"];
      date = map["date"];
      time = map["time"];
      rememberTime = map["rememberTime"];
      createTime = map['createTime'];
      complete = map["complete"];
      archive = map["archive"];
    }


  Map<String, dynamic> toMap(){
    return {
    "title" : title,
    "description" : description,
    "category" : category,
    "date" : date,
    "time" : time,
    "rememberTime" : rememberTime,
    "createTime" : createTime,
    "complete" : complete,
    "archive" : archive
    };
  }
}