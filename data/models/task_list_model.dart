import 'package:untitled3/data/models/taskModel.dart';
import 'package:untitled3/data/models/task_list_model.dart';

class taskListModel {
  String? status;
  List<taskModel>? taskList;

  taskListModel({this.status, this.taskList});

  taskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskList = <taskModel>[];
      json['data'].forEach((v) {
        taskList!.add(new taskModel.fromJson(v));
      });
    }
  }

}



