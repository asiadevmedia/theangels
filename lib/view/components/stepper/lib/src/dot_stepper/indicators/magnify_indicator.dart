// ignore_for_file: use_string_in_part_of_directives

part of indicators;

class MagnifyIndicator extends IndicatorPainter {
  @override
  void draw(Canvas canvas) {
    ShapePainter shapePainter = ShapePainter(
      canvas,
      brush,
      direction,
      dotRadius,
      activeDotOffset.left,
      activeDotOffset.top,
      activeDotOffset.right,
      activeDotOffset.bottom,
      inflationFactor: _inflate.value,
    );

    shapePainter.draw(shape);
  }

  /// Inflates the dot from (-dotRadius) to (dotRadius / 4).
  Animation get _inflate {
    return Tween(
      begin: -dotRadius!,
      end: dotRadius! / 4,
    ).animate(animationController!);
  }
}
