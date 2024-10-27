// screens/input_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/quran_viewmodel.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _surahController = TextEditingController();
  final TextEditingController _ayahController = TextEditingController();
  bool _isLoading = false;

  bool _showEnglish = true;
  bool _showBangla = true;

  final QuranViewModel _viewModel = QuranViewModel();

  bool _validateInputs() {
    final int? surahNo = int.tryParse(_surahController.text);
    final int? ayahNo = int.tryParse(_ayahController.text);

    if (surahNo == null || surahNo < 1 || surahNo > 114) {
      _showErrorDialog('Please enter a valid Surah number (1-114).');
      return false;
    }

    if (ayahNo == null || ayahNo < 1) {
      _showErrorDialog('Please enter a valid Ayah number.');
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Input Error'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: _surahController,
                placeholder: "Surah Number",
                padding: EdgeInsets.all(16),
                keyboardType: TextInputType.number,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              CupertinoTextField(
                controller: _ayahController,
                placeholder: "Ayah Number",
                padding: EdgeInsets.all(16),
                keyboardType: TextInputType.number,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Row(
                    children: [
                      Text("Show English"),
                      CupertinoSwitch(
                        value: _showEnglish,
                        onChanged: (value) {
                          setState(() {
                            _showEnglish = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text("Show Bangla"),
                      CupertinoSwitch(
                        value: _showBangla,
                        onChanged: (value) {
                          setState(() {
                            _showBangla = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CupertinoActivityIndicator(radius: 15)
                  : GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        if (_validateInputs()) {
                          setState(() {
                            _isLoading = true;
                          });
                          final result = await _viewModel.fetchAyah(
                              int.parse(_surahController.text),
                              int.parse(_ayahController.text));

                          setState(() {
                            _isLoading = false;
                          });

                          if (result != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ResultScreen(
                                  arabic: result['arabic']!,
                                  english: result['english']!,
                                  bangla: result['bangla']!,
                                  surahNumber: int.parse(_surahController.text),
                                  ayahNumber: int.parse(_ayahController.text),
                                  showEnglish: _showEnglish,
                                  showBangla: _showBangla,
                                ),
                              ),
                            );
                          } else {
                            _showErrorDialog(
                                'Ayah not found for the given Surah and Ayah.');
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.activeGreen,
                              CupertinoColors.activeGreen.withOpacity(0.8)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Text(
                          "Get Ayah",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
}
