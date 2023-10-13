import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:mytodo/constants/allDimensions.dart';
import 'package:mytodo/constants/allStrings.dart';
import 'package:mytodo/constants/appColors.dart';
import 'package:mytodo/db/sqlite.dart';
import 'package:mytodo/models/Task.dart';
import 'package:mytodo/providers/createtaskprovider.dart';
import 'package:mytodo/widgets/CustomPopupBox.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static String get routename => "/tasks/dashboard";
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String selected = "1";
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      child: Text("High"),
      value: "1",
    ),
    DropdownMenuItem(
      child: Text("Medium"),
      value: "2",
    ),
    DropdownMenuItem(
      child: Text("Low"),
      value: "3",
    )
  ];
  TextEditingController controllertitle = TextEditingController();

  Future<List<Task>> gettasks() async {
    var data = await DatabaseHelper.instance.getdata();
    debugPrint(data.toString());
    for (var dat in data) {
      var id = dat['id'].toString();
      var title = dat['title'].toString();
      var description = dat['description'].toString();
      var taskdate = dat['taskdate'].toString();
      var tasktime = dat['tasktime'].toString();
      // debugPrint(id);
      // var taskpriority = dat['taskpriority'].toString();
      Task task = Task(id, title, description, tasktime, taskdate);
      // debugPrint(task.toString());
      tasks.add(task);
      // debugPrint(id.toString());
    }
    debugPrint(tasks.toString());
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: Text(
            AllStrings.title,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amberAccent[200],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              createtaskpopup(context);
            },
            child: const Icon(Icons.add),
            tooltip: "Add Your New Task"),
        body: FutureBuilder(
            future: gettasks(),
            builder: (context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Expanded(child: Text(snapshot.error.toString()));
                }
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      var item = data[index];
                      // debugPrint(item.toString());
                      return Padding(
                        padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.cyan,boxShadow: [BoxShadow(blurRadius: 5)]),
                          padding: EdgeInsets.all(AllDimensions.px10),
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                                InkWell(onTap: (){
                                  
                                },child: Icon(Icons.edit)),
                                Icon(Icons.delete)
                              ],),
                              Text(item.title),
                              Text(item.description),
                              Text(item.taskdate),
                              Text(item.tasktime),
                              SizedBox(height: AllDimensions.px10,)
                            ],
                          ),
                         
                                             
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }

Future<dynamic> createtaskpopup(BuildContext context) {
    return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer<CreateTaskProvider>(
                      builder: (context, provider, _) {
                    return AlertDialog(
                        shadowColor: Colors.amber,
                        backgroundColor: Colors.amber,
                        title: const Center(child: Text("TASK")),
                        // scrollable: false,
                        // insetPadding: EdgeInsets.symmetric(vertical: AllDimensions.px10),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                provider.createTask(context);
                              },
                              child: const Text(
                                "Create Task",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                        content: SingleChildScrollView(
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              // Text("Title: ${provider.selected}"),
                              TextFormField(
                                controller: provider.controllertasktitle,
                                decoration: InputDecoration(
                                    hintText: "Enter The Title",
                                    label: Text("Title: ")),
                              ),
                              TextFormField(
                                controller:
                                    provider.controllertaskdescription,
                                decoration: InputDecoration(
                                    hintText: "Enter The Description",
                                    label: Text("Description: ")),
                              ),
                              TextFormField(
                                onTap: () async {
                                  DateTime? pickeddatetime =
                                      await showOmniDateTimePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    is24HourMode: false,
                                    isShowSeconds: false,
                                    isForce2Digits: false,
                                    minutesInterval: 1,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                    constraints: const BoxConstraints(
                                      maxWidth: 350,
                                      maxHeight: 650,
                                    ),
                                    transitionBuilder:
                                        (context, anim1, anim2, child) {
                                      return FadeTransition(
                                        opacity: anim1.drive(
                                          Tween(
                                            begin: 0,
                                            end: 1,
                                          ),
                                        ),
                                        child: child,
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 200),
                                    barrierDismissible: true,
                                  );
                                  var newdatetime = pickeddatetime.toString();
                                  var splitting = newdatetime.split(" ");
                                  splitting[1] =
                                      splitting[1].replaceAll(":00.000", "");
                                  provider.controllertaskdate.text =
                                      splitting[0];
                                  provider.controllertasktime.text =
                                      splitting[1];
                                  // debugPrint(splitting[1]);
                                },
                                //  debugPrint(dateTime.toString());
                                controller: provider.controllertaskdate,
                                decoration: const InputDecoration(
                                    hintText: "Pick The Task Date",
                                    label: Text("Task Date"),
                                    suffixIcon: Icon(
                                        Icons.calendar_view_day_rounded)),
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: provider.controllertasktime,
                                decoration: const InputDecoration(
                                    label: Text("Task Time"),
                                    hintText: "Your Task Time"),
                              ),
                              SizedBox(
                                height: AllDimensions.px10,
                              ),
                              const Text("Select Your Task Priority"),
                              DropdownButton(
                                dropdownColor: Colors.amber,
                                items: items,
                                // dropdownColor: Colors.blue,
                                // elevation: 1,

                                onChanged: (String? changedvalue) {
                                  provider.selected = changedvalue!;
                                  provider.checkupdate();
                                },
                                value: provider.selected,
                                isExpanded: true,
                              ),
                            ],
                          ),
                        ));
                  });
                });
  }
}
