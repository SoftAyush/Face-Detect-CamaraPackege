import 'dart:io';

import 'package:flutter/material.dart';

class PreviewWidget extends StatelessWidget {
  final String imagePath;
  const PreviewWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Icon(Icons.delete),
          ),
          const SizedBox(width: 30),
          FloatingActionButton(
            onPressed:
                () => {
                  // Navigator.pop(context, true),
                },

            child: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}
