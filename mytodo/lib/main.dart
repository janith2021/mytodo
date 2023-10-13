import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/constants/allDimensions.dart';
import 'package:mytodo/constants/allStrings.dart';
import 'package:mytodo/constants/appColors.dart';
import 'package:mytodo/pages/homepage.dart';
import 'package:mytodo/providers/createtaskprovider.dart';
import 'package:provider/provider.dart';
import 'package:selectable/selectable.dart';

void main() {
  runApp(const TODOAPP());
}

class TODOAPP extends StatelessWidget {
  const TODOAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateTaskProvider()),
      ],
      child: MaterialApp(
        routes: {
          HomePage.routename: (_) => HomePage(),
        },
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
