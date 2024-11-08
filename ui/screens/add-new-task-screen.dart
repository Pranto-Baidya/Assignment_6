import 'package:flutter/material.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/TM_Appbar.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';
import 'package:intl/intl.dart';

class addNewTask extends StatefulWidget {
  const addNewTask({super.key});

  @override
  State<addNewTask> createState() => _addNewTaskState();
}

class _addNewTaskState extends State<addNewTask> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool inProgress = false;
  bool shouldRefreshPreviousPage = false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          return;
        }
        Navigator.pop(context,shouldRefreshPreviousPage);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TM_AppBar(
      
        ),
        body: screenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 42,),
                    Text('Add new task',style: Theme.of(context).textTheme.headlineLarge?.copyWith(
      
                    ),
                    ),
                    const SizedBox(height: 24,),
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please add a title of your task';
                        }
                        return null;
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title'
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please write a description of your task';
                        }
                        return null;
                      },
                      controller: _desController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          hintText: 'Description'
                      ),
                    ),
                    const SizedBox(height: 15,),
                    ElevatedButton(
                        onPressed: _onTapAddTask,
                        child: !inProgress? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add task',style: TextStyle(color: Colors.white,fontSize: 18),),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                            )
                          ],
                        ): Center(
                          child: spinKit.normalLoader(),
                        )
                    )
      
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onTapAddTask(){
    if(_key.currentState!.validate()){
      _addTask();
      _clearFields();

    }
  }
  void _clearFields(){
    _titleController.clear();
    _desController.clear();
  }

  Future<void> _addTask() async {
    setState(() {
      inProgress = true;
    });

    String createdDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    Map<String, dynamic> requestBody = {
      "title": _titleController.text.trim(),
      "description": _desController.text.trim(),
      "status": "New",
      "createdDate": createdDate
    };

    networkResponse response = await networkCaller.postRequest(
      url: Urls.addTask,
      body: requestBody,
    );

    setState(() {
      inProgress = false;
    });

    if (response.isSuccess) {
      shouldRefreshPreviousPage = true;
      SuccessToast('Task added successfully');
     // Navigator.pop(context);
    } else {
      ErrorToast('Something went wrong');
    }
  }
}
