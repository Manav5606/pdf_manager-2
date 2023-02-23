// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/controller/image_controller.dart';
import 'dart:typed_data';
class ImageEditorScreen extends StatefulWidget {
  final ExtendedFileImageProvider provider;
  const ImageEditorScreen({required this.provider});
  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  ImageController controller = ImageController.instance;
  double sat = 1;
  double bright = 0;
  double con = 1;

  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Edit Image',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                sat = 1;
                bright = 0;
                con = 1;
              });
            },
            child: Icon(
              Icons.undo_rounded,
              size: 26,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              SmartDialog.showLoading(msg: "");
              await crop();
            },
            child: Icon(
              Icons.check,
              size: 26,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          buildImage(),
          Container(
            color: Colors.black.withOpacity(0.1),
            child: SliderTheme(
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  _buildSat(),
                  SizedBox(height: 10),
                  _buildBrightness(),
                  SizedBox(height: 10),
                  _buildCon(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFunctions(),
    );
  }

  Widget buildImage() {
    return Expanded(
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
          child: ExtendedImage(
            color: bright > 0
                ? Colors.white.withOpacity(bright)
                : Colors.black.withOpacity(-bright),
            colorBlendMode: bright > 0 ? BlendMode.lighten : BlendMode.darken,
            image: widget.provider,
            height: 400,
            width: 400,
            extendedImageEditorKey: editorKey,
            mode: ExtendedImageMode.editor,
            fit: BoxFit.contain,
            initEditorConfigHandler: (_) => EditorConfig(
              maxScale: 8.0,
              hitTestSize: 20.0,
              cropAspectRatio: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFunctions() {
    return Container(
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.flip),
            label: 'Flip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rotate_left),
            label: 'Rotate left',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rotate_right),
            label: 'Rotate right',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              flip();
              break;
            case 1:
              rotate(false);
              break;
            case 2:
              rotate(true);
              break;
          }
        },
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();
    if (rect == null) {
      return;
    }
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final Uint8List? img = state.rawImageData;

    if (img == null) {
      return;
    }

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.addOption(ColorOption.saturation(sat));
    option.addOption(ColorOption.brightness(bright + 1));
    option.addOption(ColorOption.contrast(con));

    option.outputFormat = const OutputFormat.png(100);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result?.length}');

    final Duration diff = DateTime.now().difference(start);

    print('image_editor time : $diff');

    if (result == null) return;

    File? file = File(controller.list![controller.selectedFile!].path);
    file.writeAsBytesSync(result);

    await controller.updateSelectedFile(file);
    SmartDialog.dismiss();
    pop();
  }

  void flip() {
    editorKey.currentState?.flip();
  }

  void rotate(bool right) {
    editorKey.currentState?.rotate(right: right);
  }

  void showPreviewDialog(Uint8List image) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox.fromSize(
              size: const Size.square(400),
              child: Container(
                child: Image.memory(image),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTool(
      {required String text, required double value, required Widget slider}) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
            width: 75,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.brush,
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  "$text",
                  style: TextStyle(color: Theme.of(context).accentColor),
                )
              ],
            )),
        Expanded(
          child: Container(
            height: 15,
            child: slider,
          ),
        ),
        Text(value.toStringAsFixed(2)),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _buildSat() {
    return _buildTool(
        text: 'Saturation',
        value: sat,
        slider: SliderTheme(
          data: SliderThemeData(trackHeight: 2),
          child: Slider(
              label: 'Saturation : ${sat.toStringAsFixed(2)}',
              onChanged: (double value) {
                setState(() {
                  sat = value;
                });
              },
              value: sat,
              divisions: 50,
              min: 0,
              max: 2),
        ));
  }

  Widget _buildBrightness() {
    return _buildTool(
        text: 'Brightness',
        value: bright,
        slider: SliderTheme(
          data: SliderThemeData(trackHeight: 2),
          child: Slider(
            label: 'Brightness : ${bright.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                bright = value;
              });
            },
            divisions: 50,
            value: bright,
            min: -1,
            max: 1,
          ),
        ));
  }

  Widget _buildCon() {
    return _buildTool(
        text: 'Contrast',
        value: bright,
        slider: SliderTheme(
          data: SliderThemeData(trackHeight: 2),
          child: Slider(
            label: 'Contrast : ${con.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                con = value;
              });
            },
            divisions: 50,
            value: con,
            min: 0,
            max: 4,
          ),
        ));
  }
}
