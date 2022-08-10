import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:path_drawing/path_drawing.dart';

class ClickableSvg extends StatelessWidget {
  const ClickableSvg({Key? key, required this.shapes}) : super(key: key);

  final List<Shape> shapes;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            for (final shape in shapes) {
              shape.computeShapeBorder(const Size(1030, 1978), Offset.zero & constraints.biggest);
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                ...shapes.map((shape) {
                  return _Muscle(
                    shape: shape,
                  );
                })

              ],
            );
          }
      ),
    );
  }
}

class _Muscle extends StatefulWidget {
  final Shape shape;
  const _Muscle({
    Key? key,
    required this.shape
  }) : super(key: key);

  @override
  State<_Muscle> createState() => _MuscleState();
}

class _MuscleState extends State<_Muscle> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: widget.shape.bounds,
      child: Material(
        shape: widget.shape.shapeBorder,
        color: selected ? Colors.red : widget.shape.color,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            HapticFeedback.mediumImpact();
            setState(() => selected = true);
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
              setState(() => selected = false);
              timer.cancel();
            });
          },
          onTapUp: (_) => setState(() => selected = false),
          onTapDown: (_) => setState(() => selected = true),
          onTapCancel: () => setState(() => selected = false),
          child: widget.shape.child,
        ),
      ),
    );
  }
}


class Shape {
  final String pathData;
  Color color;
  final Widget child;
  final GestureTapCallback? onTap;
  final String? contentText;
  final GestureDragUpdateCallback? onPanUpdate;
  late PathBorder shapeBorder;
  late Rect bounds;

  Shape({required this.pathData, required this.color, required this.child, this.onTap, this.onPanUpdate, this.contentText});

  void computeShapeBorder(Size inputSize, Rect rect) {
    final fs = applyBoxFit(BoxFit.contain, inputSize, rect.size);
    final r = Alignment.center.inscribe(fs.destination, rect);
    final matrix = Matrix4.translationValues(r.left, r.top, 0)
      ..scale(fs.destination.width / fs.source.width);
    final path = parseSvgPathData(pathData).transform(matrix.storage);
    bounds = path.getBounds();
    shapeBorder = PathBorder(path.shift(-bounds.topLeft));
  }
}

class PathBorder extends ShapeBorder {
  final Path path;

  const PathBorder(this.path);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ui.Path getInnerPath(ui.Rect rect, {ui.TextDirection? textDirection}) => path;

  @override
  ui.Path getOuterPath(ui.Rect rect, {ui.TextDirection? textDirection}) {
    return path.shift(rect.topLeft);
  }

  @override
  void paint(ui.Canvas canvas, ui.Rect rect, {ui.TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}