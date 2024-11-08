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
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/taskCard.dart';
import 'package:untitled3/ui/widgets/taskSummaryCard.dart';

class newTaskScreen extends StatefulWidget {
  const newTaskScreen({super.key});

  @override
  State<newTaskScreen> createState() => _newTaskScreenState();
}

class _newTaskScreenState extends State<newTaskScreen> {
  bool getNewTaskListInProgress = false;
  List<taskModel> _newTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];
  int newTaskCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildRow(),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: !getNewTaskListInProgress
                  ? ListView.separated(
                itemCount: _newTaskList.length,
                itemBuilder: (context, index) {
                  return taskCard(
                    model: _newTaskList[index],
                    onRefreshList: _refreshData,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              )
                  : Center(child: spinKit.mainLoader()),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 20, right: 10),
          child: FloatingActionButton(
            onPressed: () async {
              final bool? shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addNewTask()),
              );
              if (shouldRefresh == true) {
                _refreshData();
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
            shape: const CircleBorder(),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      getNewTaskListInProgress = true;
    });
    await getNewTaskList();
    await getTaskStatusCount();
    setState(() {
      getNewTaskListInProgress = false;
    });
  }

  Future<void> getNewTaskList() async {
    final networkResponse response = await networkCaller.getRequest(Urls.newTask);

    if (response.isSuccess) {
      final taskListModel list = taskListModel.fromJson(response.responseData);
      setState(() {
        _newTaskList = list.taskList ?? [];
      });
    } else {
      ErrorToast('Something went wrong');
    }
  }

  Future<void> getTaskStatusCount() async {
    final networkResponse response = await networkCaller.getRequest(Urls.countTask);

    if (response.isSuccess) {
      final TaskStatusCount countList = TaskStatusCount.fromJson(response.responseData);
      _taskStatusCountList = countList.taskStatusCountList ?? [];

      for (var status in _taskStatusCountList) {
        if (status.sId == "New") {
          setState(() {
            newTaskCount = status.sum ?? 0;
          });
        }
      }
    } else {
      ErrorToast('Something went wrong');
    }
  }

  Widget _buildRow() {
    return !getNewTaskListInProgress
        ? Row(
      children: [
        Expanded(
          child: TaskSummaryCard(
            count: newTaskCount,
            title: 'Newly added tasks',
            color: Colors.cyan,
            textColor: Colors.white,
          ),
        ),
      ],
    )
        : Center(child: spinKit.mainLoader());
  }
}
