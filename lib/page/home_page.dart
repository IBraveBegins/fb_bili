import 'package:fb_bili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

import '../model/video_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
}
