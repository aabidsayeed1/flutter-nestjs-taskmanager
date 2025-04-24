// import 'package:chewie/chewie.dart';
// import 'package:task_manager/core/helpers/helper_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   final String strURL;
//   final bool? looping;
//   final bool bAutoPlay;
//   final VoidCallback? clickAction;
//   final bool bActions;
//   final bool bShowControls;
//   final bool bPickAspectRatio;

//   const CustomVideoPlayer({
//     Key? key,
//     required this.strURL,
//     this.looping,
//     this.bAutoPlay = false,
//     this.clickAction = _defaultFunction,
//     this.bActions = false,
//     this.bShowControls = true,
//     this.bPickAspectRatio = false,
//   }) : super(key: key);

//   @override
//   CustomVideoPlayerState createState() => CustomVideoPlayerState();

//   static _defaultFunction() {
//     // Does nothing
//   }
// }

// class CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     initializePlayer(widget.strURL);
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     if (_videoPlayerController != null) _videoPlayerController!.dispose();
//     if (_chewieController != null) _chewieController!.dispose();
//   }

//   void initializePlayer(String strURL) async {
//     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(strURL));
//     if (_videoPlayerController != null) {
//       await _videoPlayerController!.initialize();

//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController!,
//         autoPlay: widget.bAutoPlay,
//         looping: widget.looping ?? false,
//         autoInitialize: true,
//         showControls: widget.bShowControls,
//         aspectRatio:
//             widget.bPickAspectRatio == false
//                 ? 16 /
//                     9 // For stretching the video to show full view
//                 : _videoPlayerController!.value.aspectRatio,
//         errorBuilder: (context, errorMessage) {
//           return Center(child: Text(errorMessage));
//         },
//       );

//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
//       return widget.bActions == false
//           ? GestureDetector(
//             onTap: () {
//               if (widget.clickAction != null) {
//                 widget.clickAction!();
//               }
//             },
//             child: AbsorbPointer(child: Chewie(controller: _chewieController!)),
//           )
//           : Chewie(controller: _chewieController!);
//     }

//     return HelperUI.emptyContainer();
//   }
// }
