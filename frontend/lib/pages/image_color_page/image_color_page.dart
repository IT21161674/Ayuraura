import 'dart:io';

import 'package:stress_management/values/icons/eraser_icon_icons.dart';
import 'package:stress_management/widgets/palette_widget/palette_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'dart:ui' as ui;
import '../../packages/image_flood_fill/floodfill_image.dart';
import '../../providers/main_provider.dart';

class ImageColorPage extends StatefulWidget {
  final String? title;
  final String? path;
  final int? index;
  final File? file;

  const ImageColorPage({Key? key, this.title, this.path, this.file, this.index})
      : super(key: key);

  @override
  _ImageColorPageState createState() => _ImageColorPageState();
}

class _ImageColorPageState extends State<ImageColorPage> {
  Color _fillColor = Colors.white;
  Color _colorize = Colors.white;
  int index = 0;
  double h = 600;
  double w = 600;

  // create some values
  Color pickerColor = Color(0xffffffff);
  double _currentSliderValue = 20;
  late final ImageProvider imageProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.path != null) {
      imageProvider = AssetImage(widget.path!);
    } else {
      imageProvider = FileImage(widget.file!);
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  _fillColor = pickerColor;
                  _colorize = pickerColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _currentPaletteIndex = 0;

  // Define multiple color palettes
  final List<List<Color>> _colorPalettes = [
    [
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.brown,
    ],
    [
      Colors.black,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.indigo,
      Colors.lime,
      Colors.teal,
      Colors.grey,
    ],
    [
      Colors.blueGrey,
      Colors.lightBlue,
      Colors.deepPurple,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
    ],
    [
      Colors.lightGreenAccent,
      Colors.tealAccent,
      Colors.indigoAccent,
      Colors.cyanAccent,
      Colors.amberAccent,
      Colors.deepOrangeAccent,
      Colors.limeAccent,
      Colors.brown,
      Colors.black,
    ],
    [
      Colors.white70,
      Colors.black87,
      Colors.grey,
      Colors.blueAccent,
      Colors.deepPurpleAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.yellowAccent,
    ],
  ];


  void _changeColorPalette(int index) {
    setState(() {
      _currentPaletteIndex = index;
    });
  }

  Future<void> _showPaletteSelectionDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Color Palette'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(_colorPalettes.length, (index) {
                return GestureDetector(
                  onTap: () {
                    _changeColorPalette(index);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: _colorPalettes[index]
                          .map((color) => Container(
                        width: 15,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (widget.path != null) {
          await context
              .read<MainProvider>()
              .saveImage(name: widget.path!.split('/').last);
        } else {
          await context.read<MainProvider>().saveImage(
              name: widget.file!.path.split('/').last, index: widget.index);
        }
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          // appBar: MyAppBar(
          //   title: "Color",
          // ),
          body: Column(
            children: <Widget>[
              buildRow(),
              Container(
                width: w,
                height: h,
                child: Zoom(
                  maxZoomHeight: 600,
                  maxZoomWidth: 600,
                  initZoom: 0,
                  child: Center(
                    child: FloodFillImage(
                      imageProvider: imageProvider,
                      fillColor: _fillColor,
                      avoidColor: [Colors.transparent, Colors.black],
                      tolerance: 19,
                      onFloodFillEnd: (img) {
                        context.read<MainProvider>().setImage(img);
                      },
                    ),
                  ),
                ),
              ),
              Spacer(),
              selectedColorPalette()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSaveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Coloring'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('Save Coloring'),
                Text('Do you want to save the coloring?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // await context.read<MainProvider>().saveImage();
              },
            ),
          ],
        );
      },
    );
  }

  SingleChildScrollView selectedColorPalette() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _colorPalettes[_currentPaletteIndex].map((color) {
          return PaletteItem(
            onTap: () {
              setState(() {
                _fillColor = color;
              });
            },
            color: color,
          );
        }).toList(),
      ),
    );
  }

  Row buildRow() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _fillColor = Colors.white;
            });
          },
          icon: Icon(EraserIcon.icon_eraser),
        ),
        Spacer(),
        TextButton(
          onPressed: _showPaletteSelectionDialog,
          child: const Text("Change Palette"),
        ),
      ],
    );
  }}
