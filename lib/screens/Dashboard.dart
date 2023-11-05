import 'package:flutter/material.dart';
import 'package:personal_proyecto/screens/custom.dart';
import 'package:personal_proyecto/screens/customAppbar.dart';
import 'package:personal_proyecto/screens/page1.dart';


class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
final KdekstopBreakPoint = 1024;
bool fullScreen = true;
  @override
  Widget build(BuildContext context) {
  fullScreen = (MediaQuery.of(context).size.width >= KdekstopBreakPoint) ? true : false;

    return LayoutBuilder(
      builder: (context, dimens) => Scaffold(
       drawer: !fullScreen ? buildDrawer(context) : null,
       appBar: buildAppBar(),
       body: Row(
        children: [if(fullScreen) buildDrawer(context),
        Expanded(child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            child: Page1(),
            ),
        ))],
       ),
      ),
    );
  }
}