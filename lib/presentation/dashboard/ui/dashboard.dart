import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              FarmbrosAppbar(
                appBarTitle: "Welcome Back [Farmer]",
                openSideBar: () {
                  Scaffold.of(context).openDrawer();
                },
              )
            ],
          ),
        );
      }),
      drawer: FarmbrosNavigation(),
    );
  }
}
