
import 'package:flutter/material.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
class ChewieVideoWidget1 extends StatefulWidget {
  //https://nico-android-apk.oss-cn-beijing.aliyuncs.com/landscape.mp4
  final String playUrl;

  ChewieVideoWidget1(this.playUrl);
  @override
  _ChewieVideoWidget1State createState() => _ChewieVideoWidget1State();
}

class _ChewieVideoWidget1State extends State<ChewieVideoWidget1> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.playUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowFullScreen: true,
      //aspectRatio: 3 / 2.0,
      //customControls: CustomControls(),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Chewie(controller: _chewieController,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () {
          // 点击按钮切换到全屏模式
          _chewieController.enterFullScreen();
        },
        child: Icon(Icons.fullscreen,
        color: Color(0xff333333),),
      ),
    );
  }
}
