import 'package:camera/camera.dart';
import 'package:face_detect_camara/CamaraPackeege/Constant.dart';
import 'package:face_detect_camara/CamaraPackeege/FacePainter.dart';
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
  List<Face> _faces = [];

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
    _controller = CameraController(
      cameras[1], // Use the front or back camera (adjust this)
      ResolutionPreset.high, // Adjust to your preference
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // YUV format for camera
    );

    await _controller.initialize();
    if (!mounted) return;
    _startFaceDetection();
  }

  void _startFaceDetection() {
    _controller.startImageStream((CameraImage image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final InputImage inputImage = _convertCameraImage(image);
        final faces = await _faceDetector.processImage(inputImage);

        setState(() {
          _faces = faces;
          _isFaceDetected = faces.isNotEmpty;
        });
      } catch (e) {
        debugPrint("Error detecting faces: $e");
      }

      _isProcessing = false;
    });
  }

  // Convert CameraImage to InputImage for ML Kit
  InputImage _convertCameraImage(CameraImage image) {
    final bytes = image.planes[0].bytes;
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    // Handle rotation based on device orientation
    final InputImageRotation rotation = InputImageRotation.rotation0deg;

    final InputImageFormat format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(size: imageSize, rotation: rotation, format: format, bytesPerRow: image.planes[0].bytesPerRow);

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void _captureImage() async {
    if (_isFaceDetected) {
      final XFile file = await _controller.takePicture();
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewWidget(imagePath: file.path)));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _controller.value.isInitialized
              ? Stack(
                children: [
                  Transform.scale(
                    scaleX: _controller.description.lensDirection == CameraLensDirection.front ? -1 : 1, // Flip for front camera
                    child: CameraPreview(_controller),
                  ),
                  CustomPaint(
                    isComplex: true,
                    painter: FacePainter(
                      faces: _faces,
                      imageSize: Size(_controller.value.previewSize!.height, _controller.value.previewSize!.width),
                      isFrontCamera: _controller.description.lensDirection == CameraLensDirection.front,
                    ),
                    child: Container(),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
      floatingActionButton: _isFaceDetected ? FloatingActionButton(onPressed: _captureImage, child: const Icon(Icons.camera_alt_outlined)) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
