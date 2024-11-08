import 'package:flutter/material.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/models/taskModel.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:intl/intl.dart';

class taskCard extends StatefulWidget {
  const taskCard({
    super.key,
    required this.model ,
    required this.onRefreshList,

  });

  final taskModel model;
  final VoidCallback onRefreshList;

  @override
  State<taskCard> createState() => _taskCardState();
}

class _taskCardState extends State<taskCard> {

  String selectedStatus = '';
  bool changeStatusInProgress = false;
  bool deleteTaskInProgress = false;

  @override
  void initState() {
    super.initState();
     selectedStatus = widget.model.status!;
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: [Colors.white,Colors.white]),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 0,),
              blurRadius: 2,
              spreadRadius: 0
            )
          ]
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5),
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 widget.model.title ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.model.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Created date : ${widget.model.getFormattedDate()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildChip(),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        !changeStatusInProgress? IconButton(onPressed: _onTapEdit,
                            icon: Icon(Icons.task_alt,color: Colors.black87,)
                        ):Center(child: spinKit.taskLoader()),
                        !deleteTaskInProgress?IconButton(
                            onPressed: _onTapDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.black87,
                              size: 26,
                            )
                        ):Center(child: spinKit.taskLoader())
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _onTapEdit(){
    showDialog(
        context: context,
        builder: (BuildContext context){
           return AlertDialog(
             backgroundColor: Colors.white,
             title: Text('Mark task as'),
             content: Column(

               mainAxisSize: MainAxisSize.min,
               children: ['New','Completed','In progress','Cancelled'].map((e){
                 return ListTile(
                 onTap: (){
                   _changeStatus(e);
                   Navigator.pop(context);
                 },
                   title: Text(e,style: TextStyle(color: Colors.black),),
                   selected: selectedStatus == e,
                   trailing: selectedStatus==e ? Icon(Icons.check,color: Colors.green,):null
                 );
             }).toList(),
             ),
             actions: [
               TextButton(
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   child: Text('Cancel',style: TextStyle(color: Colors.black),)
               ),

             ],
           );
        }
    );
  }

  Future<void> _onTapDelete() async {
    setState(() {
      deleteTaskInProgress = true;
    });

    final networkResponse response = await networkCaller.getRequest(Urls.deleteTask(widget.model.sId!));

    if (response.isSuccess) {
      widget.onRefreshList();
      SuccessToast('Successfully deleted');
    } else {
      ErrorToast('Something went wrong');
    }

    setState(() {
      deleteTaskInProgress = false;
    });
  }


  Future<void> _changeStatus(String newStatus)async{
   changeStatusInProgress = true;
   setState(() {
     
   });
   final networkResponse response = await networkCaller.getRequest(Urls.changeStatus(widget.model.sId!, newStatus));
   if(response.isSuccess){
    widget.onRefreshList();
   }
   else{
     changeStatusInProgress =false;
     setState(() {

     });
     ErrorToast('Something went wrong');
   }
  }

  Widget _buildChip() {
    Color getColor() {
      switch (widget.model.status) {
        case 'New':
          return Colors.cyan;
        case 'Completed':
          return Colors.greenAccent.shade700;
        case 'In progress':
          return Colors.orange;
        case 'Cancelled':
          return Colors.red;
        default:
          return Colors.grey; // Default color if no status matches
      }
    }

    return Chip(
      label: Text(
        widget.model.status ?? '',
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      backgroundColor: getColor(),
    );
  }

}
