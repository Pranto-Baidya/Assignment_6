import 'package:untitled3/data/models/taskStatusCountModel.dart';
import 'package:untitled3/data/models/task_Status_Model.dart';

class TaskStatusCount {
  String? status;
  List<TaskStatusModel>? taskStatusCountList;

  TaskStatusCount({this.status, this.taskStatusCountList});

  TaskStatusCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCountList = <TaskStatusModel>[];
      json['data'].forEach((v) {
        taskStatusCountList!.add(new TaskStatusModel.fromJson(v));
      });
    }
  }

}




