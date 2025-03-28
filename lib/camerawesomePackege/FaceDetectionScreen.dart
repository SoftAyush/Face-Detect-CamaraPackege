// import 'dart:typed_data';
//
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// class FaceDetectionScreen extends StatefulWidget {
//   @override
//   _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
// }
//
// class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
//   FaceDetector? faceDetector;
//   List<Face> faces = [];
//
//   @override
//   void initState() {
//     super.initState();
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(enableContours: true, enableLandmarks: true, performanceMode: FaceDetectorMode.accurate),
//     );
//   }
//
//   Future<void> detectFaces(img) async {
//     final Uint8List bytes = img.bytes ?? Uint8List(0);
//     if (bytes.isEmpty) return;
//
//     final InputImage inputImage = InputImage.fromBytes(
//       bytes: bytes,
//       metadata: InputImageMetadata(
//         size: Size(img.size.width, img.size.height),
//         rotation: InputImageRotation.rotation0deg,
//         format: InputImageFormat.nv21,
//         bytesPerRow: img.planes[0].bytesPerRow,
//       ),
//     );
//
//     final detectedFaces = await faceDetector!.processImage(inputImage);
//     setState(() {
//       faces = detectedFaces;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CameraAwesomeBuilder.awesome(
//         saveConfig: SaveConfig.photoAndVideo(),
//         onImageForAnalysis: (img) => detectFaces(img),
//         imageAnalysisConfig: AnalysisConfig(
//           androidOptions: const AndroidAnalysisOptions.nv21(width: 1280),
//           maxFramesPerSecond: 10, // Adjust FPS to optimize performance
//         ),
//         previewDecoratorBuilder: (cameraState, preview) {
//           return Stack(
//             children: [
//               // preview,
//               Positioned(
//                 top: 150,
//                 left: 120,
//                 child: Center(child: Text('Faces Detected: ${faces.length}', style: TextStyle(color: Colors.white, fontSize: 20))),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     faceDetector?.close();
//     super.dispose();
//   }
// }
