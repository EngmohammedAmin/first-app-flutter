// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

class AudioPermissionScreen extends StatelessWidget {
  const AudioPermissionScreen({super.key});

  static const platform = MethodChannel('com.example.first_app/permissions');

  Future<bool> checkAudioPermission() async {
    return await platform.invokeMethod('checkAudioPermission');
  }

  Future<void> requestAudioPermission() async {
    try {
      await platform.invokeMethod('requestAudioPermission');
    } on PlatformException catch (e) {
      print('Failed to request audio permission: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Audio Permissions Demo'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Check Audio Permission'),
              onPressed: () async {
                bool hasPermission = await checkAudioPermission();
                print('Has audio permission: $hasPermission');
              },
            ),
            ElevatedButton(
              child: const Text('Request Audio Permission'),
              onPressed: () {
                requestAudioPermission();
              },
            ),
          ],
        ),
      ),
    );
  }
}
