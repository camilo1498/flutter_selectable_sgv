import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:path_drawing/path_drawing.dart';

class MotionControl extends StatelessWidget {
  const MotionControl({Key? key, required this.shapes}) : super(key: key);

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
                for (final shape in shapes)
                  Positioned.fromRect(
                    rect: shape.bounds,
                    child: Material(
                      shape: shape.shapeBorder,
                      color: shape.color,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.red,
                        onTap: shape.onTap ?? (){},
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onPanUpdate: shape.onPanUpdate,
                          child: shape.child,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
      ),
    );
  }
}

class Shape {
  final String pathData;
  final Color color;
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