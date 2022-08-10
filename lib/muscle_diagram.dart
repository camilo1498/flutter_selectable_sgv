import 'package:clickeable_regions/clickable_svg.dart';
import 'package:clickeable_regions/utils/animated_card.dart';
import 'package:clickeable_regions/utils/decode_muscle_from_svg.dart';
import 'package:flutter/material.dart';

class MuscleDiagram extends StatelessWidget {
  const MuscleDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimationCardController controller = AnimationCardController();
    return Scaffold(
      body: FlipCard(
        controller: controller,
        frontWidget: InteractiveViewer(
          maxScale: 10.0,
          minScale: 1.0,
          child: ClickableSvg(shapes: DecodeMuscleFromSvg.frontMuscles),
        ),
        backWidget: InteractiveViewer(
          maxScale: 10.0,
          minScale: 1.0,
          child: ClickableSvg(shapes: DecodeMuscleFromSvg.backMuscles),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.flipCard();
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.refresh,
          size: 22,
        ),
      ),
    );
  }
}