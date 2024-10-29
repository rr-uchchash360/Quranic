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

  const ResultScreen({
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

  bool showEnglishTranslation = true;
  bool showBanglaTranslation = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: GestureDetector(
        onTap: () {
          if (showSettings) {
            setState(() {
              showSettings = false;
            });
          }
        },
        child: Stack(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 65),
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
      ),
    );
  }

  Widget _buildSurahNameSection() {
    return Container(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
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
          boxShadow: const [
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
            if (showEnglishTranslation) ...[
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
            if (showBanglaTranslation) ...[
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
            const SizedBox(height: 15),
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
    return const Positioned(
      bottom: 65,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'Preview Mode',
          style: TextStyle(
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
                onPressed: () => _shareAyahImage(context),
                style: ElevatedButton.styleFrom(
                  primary: CupertinoColors.activeGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.ios_share_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSettings = !showSettings;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupertinoColors.systemGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Icon(Icons.mode_edit_outline_rounded,
                    color: Colors.white),
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
    child: Material(
      color: Colors.green.withOpacity(0.95),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Customization',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            _buildSliderSection('Arabic', arabicFontSize, 13, 50, (value) {
                setState(() {
                  arabicFontSize = value;
                });
              }, () {
                setState(() {
                  arabicFontSize = 35;
                });
              }),
              _buildSliderSection('English', englishFontSize, 8, 40, (value) {
                setState(() {
                  englishFontSize = value;
                });
              }, () {
                setState(() {
                  englishFontSize = 20;
                });
              }),
              _buildSliderSection('Bangla', banglaFontSize, 8, 40, (value) {
                setState(() {
                  banglaFontSize = value;
                });
              }, () {
                setState(() {
                  banglaFontSize = 20;
                });
              }),
            _buildToggleSection('Show English', showEnglishTranslation, (value) {
              setState(() {
                showEnglishTranslation = value;
              });
            }),
            _buildToggleSection('Show Bangla', showBanglaTranslation, (value) {
              setState(() {
                showBanglaTranslation = value;
              });
            }),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _resetFontSizes,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Use Preset Font Size',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  void _resetFontSizes() {
    setState(() {
      arabicFontSize = 35;
      englishFontSize = 20;
      banglaFontSize = 20;
    });
  }

  Widget _buildSliderSection(String label, double value, double min, double max,
      ValueChanged<double> onChanged, VoidCallback onReset) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '$label Font Size',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onReset,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                tooltip: 'Reset',
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                constraints: BoxConstraints(),
                splashRadius: 20,
              )
            ],
          ),
          Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white24,
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
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
      style: const TextStyle(
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

  Widget _buildToggleSection(String label, bool currentValue, ValueChanged<bool> onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Switch(
        value: currentValue,
        onChanged: onChanged,
        activeColor: Colors.white,
        inactiveThumbColor: Colors.white24,
      ),
    ],
  );
}
}


