// screens/result_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class ResultScreen extends StatelessWidget {
  final String arabic;
  final String english;
  final int surahNumber;
  final int ayahNumber;

  ResultScreen({
    Key? key,
    required this.arabic,
    required this.english,
    required this.surahNumber,
    required this.ayahNumber,
  }) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  void _shareAyahImage(BuildContext context) async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        await Share.shareXFiles(
          [XFile.fromData(
            imageBytes,
            mimeType: 'image/png',
            name: 'Quranic_$surahNumber$ayahNumber.png',
          )],
        );
      }
    } catch (e) {
      print("Error sharing screenshot: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: 'Scheherazade',
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          english,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () => _shareAyahImage(context),
              child: Icon(Icons.share, color: Colors.white),
              backgroundColor: CupertinoColors.activeGreen,
            ),
          ),
        ],
      ),
    );
  }
}
