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

class cancelledTaskScreen extends StatefulWidget {
  const cancelledTaskScreen({super.key});

  @override
  State<cancelledTaskScreen> createState() => _cancelledTaskScreenState();
}

class _cancelledTaskScreenState extends State<cancelledTaskScreen> {

  bool getCancelledTaskListInProgress = false;
  bool getTaskStatusCountListInProgress = false;
  List <taskModel> _cancelledTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  int cancelledTaskCount = 0;

  @override
  void initState() {
    super.initState();
    getCancelledTaskList();
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
                child: !getCancelledTaskListInProgress? ListView.separated(
                  itemCount: _cancelledTaskList.length,
                  itemBuilder: (context,index){
                    return taskCard(model: _cancelledTaskList[index],
                      onRefreshList:_refreshData
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
      getCancelledTaskListInProgress = true;
    });
    await getCancelledTaskList();
    await getTaskStatusCount();
    setState(() {
      getCancelledTaskListInProgress = false;
    });
  }


  Future<void> getCancelledTaskList ()async{
    setState(() {
      _cancelledTaskList.clear();
      getCancelledTaskListInProgress = true;
    });

    final networkResponse response = await networkCaller.getRequest(Urls.cancelledTask);

    if(response.isSuccess){
      final taskListModel list = taskListModel.fromJson(response.responseData);
      _cancelledTaskList = list.taskList ?? [];
    }
    else{
      ErrorToast('Something went wrong');
    }

    setState(() {
      getCancelledTaskListInProgress = false;
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
        if (status.sId == "Cancelled") {
          cancelledTaskCount = status.sum ?? 0;
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
            count: cancelledTaskCount,
            title: 'Tasks are cancelled',
            color: Colors.red,
            textColor: Colors.white,
          ),
        ),
      ],
    ): Center(child: spinKit.mainLoader());
  }


}


