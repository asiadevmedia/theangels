// ignore_for_file: use_string_in_part_of_directives

part of indicators;

class ShiftIndicator extends IndicatorPainter {
  @override
  void draw(Canvas canvas) {
    ShapePainter fillPainter = ShapePainter(
      canvas,
      brush,
      direction,
      dotRadius,
      activeDotOffset.left,
      activeDotOffset.top,
      activeDotOffset.right,
      activeDotOffset.bottom,
    );

    ShapePainter borderPainter = ShapePainter(
      canvas,
      borderBrush,
      direction,
      dotRadius,
      activeDotOffset.left,
      activeDotOffset.top,
      activeDotOffset.right,
      activeDotOffset.bottom,
    );

    fillPainter.draw(shape);
    borderPainter.draw(shape);
  }
}
