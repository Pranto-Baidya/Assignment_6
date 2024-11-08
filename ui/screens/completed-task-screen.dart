import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/models/taskModel.dart';
import 'package:untitled3/data/models/taskStatusCountModel.dart';
import 'package:untitled3/data/models/task_Status_Model.dart';
import 'package:untitled3/data/models/task_list_model.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/screens/add-new-task-screen.dart';
import 'package:untitled3/ui/screens/new-task-screen.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';
import 'package:untitled3/ui/widgets/taskCard.dart';
import 'package:untitled3/ui/widgets/taskSummaryCard.dart';

class completedTaskScreen extends StatefulWidget {
  const completedTaskScreen({super.key});

  @override
  State<completedTaskScreen> createState() => _completedTaskScreenState();
}

class _completedTaskScreenState extends State<completedTaskScreen> {

  bool getCompletedTaskListInProgress = false;
  bool getTaskStatusCountListInProgress = false;
  List <taskModel> _completedTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  int completedTaskCount = 0;

  @override
  void initState() {
    super.initState();
    getCompletedTaskList();
    getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.green,
      onRefresh: _refreshData,
      child: Scaffold(

        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
              child: _buildRow(),
            ),
            const SizedBox(height: 15,),
            Expanded(
                child: !getCompletedTaskListInProgress? ListView.separated(
                  itemCount: _completedTaskList.length,
                  itemBuilder: (context,index){
                    return taskCard(model: _completedTaskList[index],
                      onRefreshList: _refreshData
                    );
                  },
                  separatorBuilder: (context,index){
                    return SizedBox(
                      height: 8,
                    );
                  },
                ):Center(
                  child: spinKit.mainLoader(),
                )
            )

          ],
        ),

      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      getCompletedTaskListInProgress = true;
    });
    await getCompletedTaskList();
    await getTaskStatusCount();
    setState(() {
      getCompletedTaskListInProgress = false;
    });
  }


  Future<void> getCompletedTaskList ()async{
    setState(() {
      _completedTaskList.clear();
      getCompletedTaskListInProgress = true;
    });

    final networkResponse response = await networkCaller.getRequest(Urls.completedTask);

    if(response.isSuccess){
      final taskListModel list = taskListModel.fromJson(response.responseData);
      _completedTaskList = list.taskList ?? [];
    }
    else{
      ErrorToast('Something went wrong');
    }

    setState(() {
      getCompletedTaskListInProgress = false;
    });
  }

  Future<void> getTaskStatusCount() async {
    setState(() {
      _taskStatusCountList.clear();
      getTaskStatusCountListInProgress = true;
    });

    final networkResponse response = await networkCaller.getRequest(Urls.countTask);

    if (response.isSuccess) {
      final TaskStatusCount countList = TaskStatusCount.fromJson(response.responseData);
      _taskStatusCountList = countList.taskStatusCountList ?? [];

      for (var status in _taskStatusCountList) {
        if (status.sId == "Completed") {
          completedTaskCount = status.sum ?? 0;
        }
      }
    } else {
      ErrorToast('Something went wrong');
    }

    setState(() {
      getTaskStatusCountListInProgress = false;
    });
  }

  Widget _buildRow() {
    return !getTaskStatusCountListInProgress
        ? Row(
      children: [
        Expanded(
          child: TaskSummaryCard(
            count: completedTaskCount,
            title: 'Tasks are completed',
            color: Colors.greenAccent.shade700,
            textColor: Colors.white,
          ),
        ),
      ],
    ): Center(child: spinKit.mainLoader());
  }
}



