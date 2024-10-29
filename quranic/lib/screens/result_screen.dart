// result_screen.dart

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

class ResultScreen extends StatefulWidget {
  final String arabic;
  final String english;
  final String bangla;
  final int surahNumber;
  final int ayahNumber;
  final bool showEnglish;
  final bool showBangla;
  final String watermarkText;
  final String surahNameArabic;
  final String surahNameTranslation;
  final String revelationPlace;

  ResultScreen({
    Key? key,
    required this.arabic,
    required this.english,
    required this.bangla,
    required this.surahNumber,
    required this.ayahNumber,
    this.showEnglish = true,
    this.showBangla = true,
    this.watermarkText = 'Made this with Quranic',
    required this.surahNameArabic,
    required this.surahNameTranslation,
    required this.revelationPlace,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  double arabicFontSize = 35;
  double englishFontSize = 20;
  double banglaFontSize = 20;
  bool showSettings = false;

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 65),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSurahNameSection(),
                    const SizedBox(height: 10),
                    _buildCenteredContent(),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
          _buildPreviewMode(),
          _buildButtonRow(context),
          if (showSettings) _buildSettingsMenu(),
        ],
      ),
    );
  }

  Widget _buildSurahNameSection() {
    return Container(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.surahNameTranslation,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.surahNameArabic,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontFamily: 'Scheherazade',
                ),
              ),
            ],
          ),
          Text(
            widget.revelationPlace,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: arabicFontSize,
                color: Colors.white,
                fontFamily: 'Scheherazade',
              ),
            ),
            if (widget.showEnglish) ...[
              const SizedBox(height: 15),
              Text(
                widget.english,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: englishFontSize,
                  color: Colors.white70,
                ),
              ),
            ],
            if (widget.showBangla) ...[
              const SizedBox(height: 15),
              Text(
                widget.bangla,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: banglaFontSize,
                  color: Colors.white70,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              '∼ Al-Quran (${widget.surahNumber}:${widget.ayahNumber})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewMode() {
    return Positioned(
      bottom: 65,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'Preview Mode',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Positioned(
      bottom: 15,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSettings = !showSettings;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: CupertinoColors.systemGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Icon(Icons.settings, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => _shareAyahImage(context),
                style: ElevatedButton.styleFrom(
                  primary: CupertinoColors.activeGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.ios_share_outlined, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      width: 220,
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text('Font Sizes',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 20),
              Text('Arabic', style: TextStyle(color: Colors.white)),
              Material(
                child: Slider(
                  value: arabicFontSize,
                  min: 30,
                  max: 50,
                  divisions: 21,
                  label: arabicFontSize.round().toString(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.white70,
                  onChanged: (value) {
                    setState(() {
                      arabicFontSize = value;
                    });
                  },
                ),
              ),
              Text('English', style: TextStyle(color: Colors.white)),
              Material(
                child: Slider(
                  value: englishFontSize,
                  min: 20,
                  max: 40,
                  divisions: 21,
                  label: englishFontSize.round().toString(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.white70,
                  onChanged: (value) {
                    setState(() {
                      englishFontSize = value;
                    });
                  },
                ),
              ),
              Text('Bangla', style: TextStyle(color: Colors.white)),
              Material(
                child: Slider(
                  value: banglaFontSize,
                  min: 20,
                  max: 40,
                  divisions: 21,
                  label: banglaFontSize.round().toString(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.white70,
                  onChanged: (value) {
                    setState(() {
                      banglaFontSize = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
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
      final imagePath = path.join(directory.path,
          'Quranic_${widget.surahNumber}:${widget.ayahNumber}.png');
      final imageFile = File(imagePath);

      try {
        final originalImage = await _loadImage(Uint8List.fromList(image));
        final watermarkedImage =
            await _addWatermark(originalImage, widget.watermarkText);
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
        const SnackBar(content: Text('Failed to render image!')),
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
      style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      (original.width - textPainter.width) / 2,
      original.height - textPainter.height - 135,
    );

    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    return await picture.toImage(original.width, original.height);
  }
}
