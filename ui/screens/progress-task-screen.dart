import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/models/taskModel.dart';
import 'package:untitled3/data/models/taskStatusCountModel.dart';
import 'package:untitled3/data/models/task_Status_Model.dart';
import 'package:untitled3/data/models/task_list_model.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/taskCard.dart';
import 'package:untitled3/ui/widgets/taskSummaryCard.dart';

class progressTaskScreen extends StatefulWidget {
  const progressTaskScreen({super.key});

  @override
  State<progressTaskScreen> createState() => _progressTaskScreenState();
}

class _progressTaskScreenState extends State<progressTaskScreen> {

  bool getProgressTaskListInProgress = false;
  bool getTaskStatusCountListInProgress = false;
  List<taskModel> _progressTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];


  int inProgressTaskCount = 0;

  @override
  void initState() {
    getProgressTaskList();
    getTaskStatusCount();
    super.initState();
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
              child: !getProgressTaskListInProgress
                  ? ListView.separated(
                itemCount: _progressTaskList.length,
                itemBuilder: (context, index) {
                  return taskCard(
                    model: _progressTaskList[index],
                    onRefreshList: _refreshData
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              ): Center(child: spinKit.mainLoader()),
            ),

          ],
        ),

      ),
    );
  }

  Future<void> getProgressTaskList() async {
    setState(() {
      _progressTaskList.clear();
      getProgressTaskListInProgress = true;
    });

    final networkResponse response = await networkCaller.getRequest(Urls.inProgressTask);

    if (response.isSuccess) {
      final taskListModel list = taskListModel.fromJson(response.responseData);
      _progressTaskList = list.taskList ?? [];
    } else {
      ErrorToast('Something went wrong');
    }

    setState(() {
      getProgressTaskListInProgress = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      getProgressTaskListInProgress = true;
    });
    await getProgressTaskList();
    await getTaskStatusCount();
    setState(() {
      getProgressTaskListInProgress = false;
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
        if (status.sId == "In progress") {
          inProgressTaskCount = status.sum ?? 0;
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
            count: inProgressTaskCount,
            title: 'Tasks are in progress',
            color: Colors.orange,
            textColor: Colors.white,
          ),
        ),
      ],
    ): Center(child: spinKit.mainLoader());
  }
}


