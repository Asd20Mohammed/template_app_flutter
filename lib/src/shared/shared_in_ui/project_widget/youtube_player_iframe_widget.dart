import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AppYoutubePlayerIframe extends StatefulWidget {
  const AppYoutubePlayerIframe({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.mute = true,
    this.showControls = true,
  });

  final String url;
  final bool autoPlay;
  final bool mute;
  final bool showControls;

  @override
  State<AppYoutubePlayerIframe> createState() => _AppYoutubePlayerIframeState();
}

class _AppYoutubePlayerIframeState extends State<AppYoutubePlayerIframe> {
  late YoutubePlayerController _controller;
  late String _videoId;

  @override
  void initState() {
    super.initState();

    // تحاول استخراج videoId من أي رابط يوتيوب (watch / shorts / youtu.be / embed)
    _videoId = YoutubePlayer.convertUrlToId(widget.url) ?? widget.url;

    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: widget.mute,
        controlsVisibleAtStart: true,
        hideControls: !widget.showControls,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    if (Get.isOverlaysOpen) {
      Get.back();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // نجعل الفيديو يملأ الشاشة بالكامل
              Positioned.fill(child: player),

              // زر إغلاق أعلى اليسار
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _close,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
