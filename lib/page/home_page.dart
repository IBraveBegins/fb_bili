import 'package:fb_bili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

import '../model/video_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var listener;
  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      print('current:${current.page}');
      print('pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开首页: onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页: onPause');
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('首页'),
          MaterialButton(
            onPressed: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
                  args: {'videoMo': VideoModel(1001)});
            },
            child: const Text('详情'),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
