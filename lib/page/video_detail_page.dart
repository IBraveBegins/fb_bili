import 'package:fb_bili/model/video_model.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage(this.videoModel, {super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('视频详情页，vid：${widget.videoModel.vid}'),
      ),
    );
  }
}
