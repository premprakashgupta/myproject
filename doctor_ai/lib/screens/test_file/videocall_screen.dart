// import 'package:doctor_ai/utility/signaling.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);

//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   Signaling signaling = Signaling();
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   String? roomId;
//   TextEditingController textEditingController = TextEditingController(text: '');

//   @override
//   void initState() {
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();

//     signaling.onAddRemoteStream = ((stream) {
//       _remoteRenderer.srcObject = stream;
//       setState(() {});
//     });
//     signaling.openUserMedia(_localRenderer, _remoteRenderer);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Welcome to Flutter Explained - WebRTC"),
//         actions: [
//           SizedBox(
//             width: 150,
//             child: TextFormField(
//               decoration:
//                   const InputDecoration(hintText: "Join the room here.."),
//               controller: textEditingController,
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SizedBox(
//             width: double.maxFinite,
//             height: double.maxFinite,
//             child: RTCVideoView(
//               _localRenderer,
//               mirror: true,
//               objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 10,
//             width: 120,
//             height: 170,
//             child: RTCVideoView(_remoteRenderer),
//           ),
//           Positioned(
//             bottom: 50,
//             left: 0,
//             width: double.maxFinite,
//             child: Wrap(
//               spacing: 8.0,
//               runSpacing: 30.0,
//               children: [
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     roomId = await signaling.createRoom(_remoteRenderer);
//                     textEditingController.text = roomId!;
//                     setState(() {});
//                   },
//                   child: const Text("new meeting"),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add roomId
//                     signaling.joinRoom(
//                       textEditingController.text.trim(),
//                       _remoteRenderer,
//                     );
//                   },
//                   child: const Text("Join meeting"),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     signaling
//                         .toggleMicrophoneMute(!signaling.isMicrophoneMuted);
//                     setState(() {});
//                   },
//                   child: Text(signaling.isMicrophoneMuted
//                       ? 'Unmute Microphone'
//                       : 'Mute Microphone'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     signaling.hangUp(_localRenderer);
//                   },
//                   child: const Text("Hangup"),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
