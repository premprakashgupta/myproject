// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class CallScreen extends StatefulWidget {
//   final String channelName;

//   CallScreen({required this.channelName});

//   @override
//   _CallScreenState createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebRTC();
//     _getUserMedia();
//   }

//   void _initializeWebRTC() async {
//     await WebRTC.initialize();

//     final configuration = RTCConfiguration(
//       iceServers: [
//         RTCIceServer(
//           url: 'stun:stun.l.google.com:19302',
//         ),
//       ],
//     );

//     _peerConnection = await createPeerConnection(configuration);
//     _peerConnection?.onAddStream = _onAddStream;
//   }

//   void _getUserMedia() async {
//     final mediaConstraints = <String, dynamic>{
//       'audio': true,
//       'video': false, // We are implementing audio calling, so we don't need video.
//     };

//     final mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//     _peerConnection?.addStream(mediaStream);

//     setState(() {
//       _localStream = mediaStream;
//     });
//   }

//   void _onAddStream(MediaStream stream) {
//     // Implement audio stream handling if needed (e.g., for speaker or mute controls).
//   }

//   void _hangUp() {
//     _localStream?.getTracks().forEach((track) => track.stop());
//     _peerConnection?.close();
//     _peerConnection = null;
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Call'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.phone_in_talk,
//               size: 100,
//               color: Colors.green,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'In a Call',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _hangUp,
//               child: Text('Hang Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
