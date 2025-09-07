// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerFullPage extends StatefulWidget {
//   final VideoData? videoData;
//
//   const VideoPlayerFullPage({
//     super.key,
//     required this.videoData,
//   });
//
//   @override
//   State createState() => _VideoPlayerFullPageState();
// }
//
// class _VideoPlayerFullPageState extends State<VideoPlayerFullPage> {
//   late VideoPlayerController videoController;
//   bool isInitPlaying = false;
//   bool isBuffering = false;
//   double videoWidth = 0;
//   double videoHeight = 0;
//   double _currentSliderValue = 0.0;
//
//   @override
//   void initState() {
//     if (widget.videoData!.videoFile != null) {
//       videoController =
//           VideoPlayerController.file(widget.videoData!.videoFile!);
//     } else {
//       videoController =
//           VideoPlayerController.networkUrl(widget.videoData!.videoUrl!);
//     }
//     videoController
//       ..initialize().then((value) {
//         videoController.play();
//         videoController.setLooping(true);
//         setState(() {
//           _currentSliderValue = 0.0;
//           isInitPlaying = true;
//           videoWidth = videoController.value.size.width;
//           videoHeight = videoController.value.size.height;
//         });
//       })
//       ..addListener(videoListener);
//     super.initState();
//   }
//
//   void videoListener() {
//     setState(() {
//       isBuffering = videoController.value.isBuffering;
//       _currentSliderValue = videoController.value.position.inSeconds.toDouble();
//     });
//   }
//
//   @override
//   void dispose() {
//     videoController.removeListener(videoListener);
//     videoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         shape: Border(),
//         leading: BackButton(
//           color: Colors.white,
//         ),
//       ),
//       body: Container(
//         color: Colors.grey,
//         height: size.height,
//         width: size.width,
//         child: widget.videoData == null
//             ? Center(
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.0),
//                     color: Colors.white24,
//                   ),
//                   child: Column(
//                     children: const [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Icon(
//                         Icons.error_outline,
//                         size: 50,
//                       ),
//                       SizedBox(
//                         height: 70,
//                       ),
//                       Text(
//                         '无数据',
//                         style: TextStyle(fontSize: 20, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             : GestureDetector(
//                 onTap: () {
//                   print('============>视频点击 ');
//                   setState(() {
//                     videoController.value.isPlaying
//                         ? videoController.pause()
//                         : videoController.play();
//                   });
//                 },
//                 child: Container(
//                   height: size.height,
//                   width: size.width,
//                   decoration: const BoxDecoration(color: Colors.black),
//                   child: Stack(
//                     children: <Widget>[
//                       videoWidth > videoHeight
//                           ? Center(
//                               child: AspectRatio(
//                                 aspectRatio: videoController.value.aspectRatio,
//                                 child: VideoPlayer(videoController),
//                               ),
//                             )
//                           : SizedBox.expand(
//                               child: FittedBox(
//                               fit: BoxFit.cover,
//                               alignment: Alignment.centerLeft,
//                               child: SizedBox(
//                                 width: videoController.value.size.width,
//                                 height: videoController.value.size.height,
//                                 child: VideoPlayer(videoController),
//                               ),
//                             )),
//                       Center(
//                         child: Container(
//                           decoration: const BoxDecoration(),
//                           child: isPlaying(),
//                         ),
//                       ),
//                       isBuffering || !videoController.value.isInitialized
//                           ? const Center(
//                               child: SizedBox(
//                                 width: 40,
//                                 height: 40,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.pink,
//                                 ),
//                               ),
//                             )
//                           : const SizedBox(),
//                       Positioned(bottom: 20, child: bottomPanel(size)),
//                       Positioned(
//                           bottom: 20,
//                           child: Container(
//                             width: size.width,
//                             height: 5,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 20, right: 20),
//                               child: SliderTheme(
//                                   data: defaultSliderTheme,
//                                   child: Slider(
//                                     value: _currentSliderValue,
//                                     min: 0.0,
//                                     max: videoController
//                                         .value.duration.inSeconds
//                                         .toDouble(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _currentSliderValue = value;
//                                         videoController.seekTo(
//                                             Duration(seconds: value.toInt()));
//                                       });
//                                     },
//                                   )),
//                             ),
//                           )),
//                       videoWidth > videoHeight
//                           ? GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => FullScreenVideoPage(
//                                           videoController: videoController)),
//                                 );
//                               },
//                               child: Padding(
//                                   padding: const EdgeInsets.only(top: 400),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 110,
//                                       height: 40,
//                                       child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                             color: Colors.white12,
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               SizedBox(
//                                                 width: 3,
//                                               ),
//                                               Icon(
//                                                 Icons.fullscreen,
//                                                 color: Colors.white,
//                                               ),
//                                               Container(
//                                                 height: 25,
//                                                 width: 60,
//                                                 child: Text(
//                                                   '全屏观看',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 3,
//                                               ),
//                                             ],
//                                           )),
//                                     ),
//                                   )))
//                           : const SizedBox(),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
//
//   Widget isPlaying() {
//     if (videoController.value.isInitialized) {
//       return videoController.value.isPlaying
//           ? const SizedBox()
//           : Image.asset(
//               'assets/images/start.png',
//               width: 80,
//               height: 80,
//               color: Colors.white54,
//             );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   Widget bottomPanel(Size size) {
//     return Container(
//       padding: EdgeInsets.all(40),
//       width: size.width,
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           TextButton(
//               style: ButtonStyle(
//                 alignment: Alignment.topCenter,
//                 backgroundColor: WidgetStateProperty.all(Colors.white24),
//                 fixedSize: WidgetStateProperty.all(Size(100, 40)),
//                 shape: WidgetStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10))),
//               ),
//               onPressed: () {},
//               child: Text(
//                 "显示曲谱",
//                 style: TextStyle(color: Colors.white),
//               )),
//           TextButton(
//               style: ButtonStyle(
//                 alignment: Alignment.topCenter,
//                 backgroundColor: WidgetStateProperty.all(Colors.pink),
//                 fixedSize: WidgetStateProperty.all(Size(100, 40)),
//                 shape: WidgetStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10))),
//               ),
//               onPressed: () {},
//               child: Text(
//                 "下一步",
//                 style: TextStyle(color: Colors.white),
//               )),
//         ],
//       ),
//     );
//   }
// }
//
// class FullScreenVideoPage extends StatefulWidget {
//   final VideoPlayerController videoController;
//
//   const FullScreenVideoPage({Key? key, required this.videoController})
//       : super(key: key);
//
//   @override
//   _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
// }
//
// class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
//   double _currentSliderValue = 0.0;
//   bool isBuffering = false;
//   bool isInitPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     setState(() {
//       _currentSliderValue = 0.0;
//       isInitPlaying = true;
//     });
//     widget.videoController.addListener(videoListener);
//   }
//
//   void videoListener() {
//     setState(() {
//       isBuffering = widget.videoController.value.isBuffering;
//       _currentSliderValue =
//           widget.videoController.value.position.inSeconds.toDouble();
//     });
//   }
//
//   @override
//   void dispose() {
//     widget.videoController.removeListener(videoListener);
//     super.dispose();
//   }
//
//   Widget isPlaying() {
//     if (widget.videoController.value.isInitialized) {
//       return widget.videoController.value.isPlaying
//           ? const SizedBox()
//           : Image.asset(
//               'assets/images/start.png',
//               width: 80,
//               height: 80,
//               color: Colors.white54,
//             );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             shape: Border(),
//             leading: BackButton(
//               color: Colors.white,
//               onPressed: () {
//                 SystemChrome.setPreferredOrientations(
//                     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           backgroundColor: Colors.black,
//           body: GestureDetector(
//             onTap: () {
//               setState(() {
//                 widget.videoController.value.isPlaying
//                     ? widget.videoController.pause()
//                     : widget.videoController.play();
//               });
//             },
//             child: Stack(
//               children: [
//                 Center(
//                   child: AspectRatio(
//                     aspectRatio: widget.videoController.value.aspectRatio,
//                     child: VideoPlayer(widget.videoController),
//                   ),
//                 ),
//                 Center(
//                   child: Container(
//                     decoration: const BoxDecoration(),
//                     child: isPlaying(),
//                   ),
//                 ),
//                 isBuffering || !widget.videoController.value.isInitialized
//                     ? const Center(
//                         child: SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: CircularProgressIndicator(
//                             color: Colors.pink,
//                           ),
//                         ),
//                       )
//                     : const SizedBox(),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 10),
//                     height: 10,
//                     child: Padding(
//                         padding: EdgeInsets.only(left: 20, right: 20),
//                         child: SliderTheme(
//                             data: defaultSliderTheme,
//                             child: Slider(
//                               value: _currentSliderValue,
//                               min: 0.0,
//                               max: widget
//                                   .videoController.value.duration.inSeconds
//                                   .toDouble(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _currentSliderValue = value;
//                                   widget.videoController
//                                       .seekTo(Duration(seconds: value.toInt()));
//                                 });
//                               },
//                             ))),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         onWillPop: () async {
//           ScreenUtils.exitFullscreen();
//           Navigator.pop(context);
//           return false;
//         });
//   }
// }
//
// const defaultSliderTheme = SliderThemeData(
//   trackHeight: 2,
//   // 轨道高度
//   trackShape: const RoundedRectSliderTrackShape(),
//   // 轨道形状，可以自定义
//   activeTrackColor: Colors.white,
//   // 激活的轨道颜色
//   inactiveTrackColor: Colors.white10,
//   // 未激活的轨道颜色
//   thumbColor: Colors.white,
//   // 滑块颜色
//   thumbShape: const RoundSliderThumbShape(
//       //  滑块形状，可以自定义
//       enabledThumbRadius: 3 // 滑块大小
//       ),
//   overlayShape: const RoundSliderOverlayShape(
//     overlayRadius: 10, // 设置滑块的覆盖层半径
//   ),
// );
//
// class VideoData {
//   Uri? videoUrl; //视频地址
//   File? videoFile; //视频地址
//   final String userName; //发布者名
//   final String description; //视频描述
//   final String title; //视频标题
//
//   VideoData({
//     this.videoUrl,
//     this.videoFile,
//     required this.userName,
//     required this.description,
//     required this.title,
//   });
// }
