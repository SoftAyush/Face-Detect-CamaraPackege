import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_detect_camara/CamaraPackeege/Constant.dart';
import 'package:face_detect_camara/CamaraPackeege/PreviewWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isProcessing = false;
  bool _isFaceDetected = false;
  Timer? _captureTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate, // More accurate detection
      ),
    );
  }

  void _initializeCamera() async {
    _controller = CameraController(cameras[1], ResolutionPreset.high, enableAudio: false);
    await _controller.initialize();
    if (!mounted) return;
    _startFaceDetection();
  }

  void _startFaceDetection() {
    Timer.periodic(const Duration(microseconds: 500), (timer) async {
      if (!_controller.value.isInitialized || _isProcessing) return;
      _isProcessing = true;

      try {
        final XFile file = await _controller.takePicture();
        final InputImage inputImage = InputImage.fromFilePath(file.path);
        final faces = await _faceDetector.processImage(inputImage);

        setState(() {
          _isFaceDetected = faces.isNotEmpty;
        });
      } catch (e) {
        debugPrint("Error detecting faces: $e");
      }

      _isProcessing = false;
    });
  }

  void _captureImage() async {
    if (_isFaceDetected) {
      final XFile file = await _controller.takePicture();
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewWidget(imagePath: file.path)));
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Face detected! Image saved: ${file.path}')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _captureTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _isFaceDetected ? _captureImage : null, // Enable button only if face detected
                style: ElevatedButton.styleFrom(backgroundColor: _isFaceDetected ? Colors.blue : Colors.grey),
                child: Text("Capture Image"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
