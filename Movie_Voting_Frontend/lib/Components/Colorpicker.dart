import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:movie_voting_frontend/Components/ColorpickerController.dart';

class Colorpicker extends StatefulWidget {
  const Colorpicker({Key? key, required this.text, required this.colorController}) : super(key: key);

  final String text;
  final ColorpickerController colorController;

  @override
  State<Colorpicker> createState() => _Colorpicker();
}

class _Colorpicker extends State<Colorpicker> {
  final _colorNotifier = ValueNotifier<Color>(Colors.green);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(widget.text),
          ),
          ValueListenableBuilder<Color>(
              valueListenable: _colorNotifier,
              builder: (_, color, __) {
                return ColorPicker(
                  color: color,
                  onChanged: (value){ color = value; widget.colorController.color = value;}

                );
              }
          ),

        ],
      ),
    );
  }
}