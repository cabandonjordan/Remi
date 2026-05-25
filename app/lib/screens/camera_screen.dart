import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healing Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Align your injury within the frame',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Take photo logic
              },
              child: const Text('Capture'),
            )
          ],
        ),
      ),
    );
  }
}
