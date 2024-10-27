import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ResultScreen extends StatelessWidget {
  final String arabic;
  final String english;
  final String bangla;
  final int surahNumber;
  final int ayahNumber;
  final bool showEnglish;
  final bool showBangla;
  final String watermarkText; // New parameter for custom watermark text

  ResultScreen({
    Key? key,
    required this.arabic,
    required this.english,
    required this.bangla,
    required this.surahNumber,
    required this.ayahNumber,
    this.showEnglish = true,
    this.showBangla = true,
    this.watermarkText = 'Made this with Quranic', // Default value
  }) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

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
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: 'Scheherazade',
                          ),
                        ),
                        if (showEnglish) ...[
                          const SizedBox(height: 15),
                          Text(
                            english,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        if (showBangla) ...[
                          const SizedBox(height: 15),
                          Text(
                            bangla,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          '∼ Al-Quran ($surahNumber:$ayahNumber)',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
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
              backgroundColor: CupertinoColors.activeGreen,
              child: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _encodePng(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Error encoding image to PNG');
    }
    return byteData.buffer.asUint8List();
  }

  Future<void> _shareAyahImage(BuildContext context) async {
    final Uint8List? image = await screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          path.join(directory.path, 'Quranic_$surahNumber:$ayahNumber.png');
      final imageFile = File(imagePath);

      try {
        final originalImage = await _loadImage(Uint8List.fromList(image));
        final watermarkedImage =
            await _addWatermark(originalImage, watermarkText);

        await imageFile.writeAsBytes(await _encodePng(watermarkedImage));
        await Share.shareXFiles([XFile(imageFile.path)]);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image!')),
          );
        }
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image!')),
      );
    }
  }

  Future<ui.Image> _loadImage(Uint8List data) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(data, (image) {
      return completer.complete(image);
    });
    return completer.future;
  }

  Future<ui.Image> _addWatermark(
      ui.Image original, String watermarkText) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(original, Offset.zero, Paint());

    final textSpan = TextSpan(
      text: watermarkText,
      style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Roboto'),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      (original.width - textPainter.width) / 2,
      original.height - textPainter.height - 100,
    );

    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    return await picture.toImage(original.width, original.height);
  }
}
