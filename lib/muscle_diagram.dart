import 'package:clickeable_regions/example.dart';
import 'package:clickeable_regions/utils/decode_muscle_from_svg.dart';
import 'package:flutter/material.dart';

class MuscleDiagram extends StatelessWidget {
  const MuscleDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: InteractiveViewer(
        maxScale: 10.0,
        minScale: 1.0,
        child: MotionControl(shapes: DecodeMuscleFromSvg.frontMuscles),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.refresh,
          size: 22,
        ),
      ),
    );
  }
}