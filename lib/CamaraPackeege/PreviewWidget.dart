import 'dart:io';

import 'package:flutter/material.dart';

class PreviewWidget extends StatelessWidget {
  final String imagePath;
  const PreviewWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview Image")),
      body: Center(child: imagePath.isNotEmpty ? Image.file(File(imagePath)) : Text("No Image Captured")),
    );
  }
}
