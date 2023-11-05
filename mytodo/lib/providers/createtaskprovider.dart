import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/db/sqlite.dart';
import 'package:mytodo/pages/homepage.dart';

class CreateTaskProvider extends ChangeNotifier {
  TextEditingController controllertaskdate = TextEditingController();
  TextEditingController controllertasktime = TextEditingController();
  TextEditingController controllertasktitle = TextEditingController();
  TextEditingController controllertaskdescription = TextEditingController();
  TextEditingController controllertaskpriority = TextEditingController();

  String selected = "1";

  checkupdate() {
    notifyListeners();
  }

  createTask(BuildContext context) async {
    // DatabaseHelper.instance.dropdatabase();
    int i = await DatabaseHelper.instance.insertdata({
      DatabaseHelper.table1title: controllertasktitle.text,
      DatabaseHelper.table1description: controllertaskdescription.text,
      DatabaseHelper.table1taskdate: controllertaskdate.text,
      DatabaseHelper.table1tasktime: controllertasktime.text,
      DatabaseHelper.table1taskpriority: selected,
    });
    if (!i.isNaN) {
      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
      notifyListeners();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "/tasks/dashboard");
      // ignore: use_build_context_synchronously
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: 'Success',
              text: 'Task Created Successfully',
              type: ArtSweetAlertType.success));

      // return true;
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "/tasks/dashboard");
      // ignore: use_build_context_synchronously
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Error",
            text: "Task Creation Failed",
            type: ArtSweetAlertType.danger,
          ));
      // return false;
    }
  }

  updatetask(BuildContext context, id) async {
    int i = await DatabaseHelper.instance.updatedata(
        controllertaskdate.text,
        controllertasktime.text,
        controllertasktitle.text,
        controllertaskdescription.text,
        id);
    // debugPrint(id);
    // debugPrint(i.toString());
    // // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, "/tasks/dashboard");
    // debugPrint(data.toString());
  }

  deletetask(BuildContext context, id) async {
    debugPrint("Hello");
    var data = await DatabaseHelper.instance.deletedata(id);
    debugPrint(data.toString());
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
    // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, "/tasks/dashboard");
    // notifyListeners();
  }
}
