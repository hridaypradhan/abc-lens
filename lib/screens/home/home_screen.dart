import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:text_analyzer/screens/home/widgets/ocr_text_widget.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _torchSelected = false, _displayText = true, _separateText = true;
  final int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  final bool _multipleOcr = true, _waitTapOcr = true;
  Size? _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    FlutterMobileVision.start().then(
      (previewSizes) => setState(
        () {
          if (previewSizes[_cameraOcr] == null) {
            return;
          }
          _previewOcr = const Size(1000, 2000);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Bounce(
                    duration: const Duration(milliseconds: 200),
                    onPressed: () {
                      setState(
                        () {
                          _torchSelected = !_torchSelected;
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: size.width * 0.12,
                      backgroundColor: _torchSelected
                          ? Colors.yellow[700]
                          : Colors.grey[300],
                      child: Icon(
                        _torchSelected ? Icons.flash_on : Icons.flash_off,
                        color: _torchSelected ? Colors.white : Colors.black,
                        size: size.width * 0.1,
                      ),
                    ),
                  ),
                  Bounce(
                    duration: const Duration(milliseconds: 200),
                    onPressed: () {
                      setState(
                        () {
                          _displayText = !_displayText;
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: size.width * 0.12,
                      backgroundColor:
                          _displayText ? Colors.blue[300] : Colors.grey[300],
                      child: Icon(
                        _displayText ? Icons.visibility : Icons.visibility_off,
                        color: _displayText ? Colors.white : Colors.black,
                        size: size.width * 0.1,
                      ),
                    ),
                  ),
                  Bounce(
                    duration: const Duration(milliseconds: 200),
                    onPressed: () {
                      setState(
                        () {
                          _separateText = !_separateText;
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: size.width * 0.12,
                      backgroundColor: _separateText
                          ? Colors.green[300]
                          : Colors.orange[200],
                      child: Text(
                        _separateText ? 'Separate\nText' : 'All\nText',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Bounce(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'FIND TEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.camera_enhance,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    color: Colors.pink[200],
                  ),
                ),
                duration: const Duration(milliseconds: 200),
                onPressed: () {
                  _read(context);
                },
              ),
              const SizedBox(height: 30.0),
              if (_textsOcr.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: _separateText
                        ? _textsOcr
                            .map(
                              (ocrText) => OcrTextWidget(ocrText),
                            )
                            .toList()
                        : [
                            Builder(
                              builder: (context) {
                                String concatenated = '';
                                for (OcrText text in _textsOcr) {
                                  concatenated += text.value + ' ';
                                }
                                return OcrTextWidget(
                                  OcrText(
                                    concatenated,
                                    language: _textsOcr.first.language,
                                  ),
                                );
                              },
                            ),
                          ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _read(BuildContext context) async {
    List<OcrText> texts = [];
    Size _scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchSelected,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        forceCloseCameraOnTap: true,
        imagePath: '',
        showText: _displayText,
        preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
        scanArea: Size(_scanpreviewOcr.width - 20, _scanpreviewOcr.height - 20),
        fps: 2.0,
      );
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to recognize text',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }
}
