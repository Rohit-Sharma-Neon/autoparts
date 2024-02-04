import 'package:autoparts/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  const CustomVideoPlayer({Key? key, this.videoUrl}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.videoUrl ?? 'https://media.istockphoto.com/videos/disassembled-car-engine-safety-seat-instrument-panel-accelerator-4k-video-id1281782411'
    )..initialize().then((_) {
      _controller?.play();
      _controller?.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          _controller!.value.isPlaying
              ? _controller!.pause()
              : _controller!.play();
        });
      },
      child: Container(
        height: 250,
        color: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        child:  _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : Container(),
        // Column(
        //   children: [
        //     Image.asset(
        //       AppImages.advertisementPlay,
        //
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
