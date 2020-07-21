import 'package:flutter/material.dart';

import 'package:polymathic/pages/task_page.dart';
import 'package:polymathic/pages/stats_page.dart';
import 'package:polymathic/pages/about_page.dart';
import 'package:polymathic/utils/constants.dart';

class TabBarNavigation extends StatefulWidget {
  @override
  _TabBarNavigationState createState() => _TabBarNavigationState();
}

class _TabBarNavigationState extends State<TabBarNavigation> {
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Tasks'),
    const Tab(text: 'Stats'),
    const Tab(text: 'About'),
  ];

  final List<Widget> pages = <Widget>[
    TaskPage(),
    StatsPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabs,
              isScrollable: false,
              unselectedLabelColor: kDisabledTextColor,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
