import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize; // Add the image size
  final bool isFrontCamera; // To handle mirroring

  FacePainter({required this.faces, required this.imageSize, required this.isFrontCamera});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

    for (Face face in faces) {
      Rect boundingBox = face.boundingBox;

      // Scale bounding box to match preview size
      double scaleX = size.width / imageSize.width;
      double scaleY = size.height / imageSize.height;

      double left = boundingBox.left * scaleX;
      double top = boundingBox.top * scaleY;
      double right = boundingBox.right * scaleX;
      double bottom = boundingBox.bottom * scaleY;

      Rect scaledBox = Rect.fromLTRB(left, top, right, bottom);

      if (isFrontCamera) {
        // Flip horizontally for front camera
        double centerX = size.width / 2;
        scaledBox = Rect.fromLTRB(2 * centerX - scaledBox.right, scaledBox.top, 2 * centerX - scaledBox.left, scaledBox.bottom);
      }

      canvas.drawRect(scaledBox, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
