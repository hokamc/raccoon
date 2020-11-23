import 'dart:math' as math;

import 'package:flutter/material.dart';

class BubblePop extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final double size;

  const BubblePop({Key key, @required this.child, this.duration = const Duration(milliseconds: 300), this.size = 30.0})
      : assert(child != null),
        super(key: key);

  @override
  BubblePopState createState() => BubblePopState();
}

// author @ like_button
class BubblePopState extends State<BubblePop> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _outerCircleAnimation;
  Animation<double> _innerCircleAnimation;
  Animation<double> _scaleAnimation;
  Animation<double> _bubblesAnimation;

  _BubblesColor _bubblesColor = const _BubblesColor(
    dotPrimaryColor: Color(0xFFFFC107),
    dotSecondaryColor: Color(0xFFFF9800),
    dotThirdColor: Color(0xFFFF5722),
    dotLastColor: Color(0xFFF44336),
  );

  _CircleColor _circleColor = const _CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107));

  double _bubblesSize;
  double _circleSize;

  @override
  void initState() {
    _bubblesSize = widget.size * 2.0;
    _circleSize = widget.size * 0.8;
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> animate = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.35,
          0.7,
          curve: _OvershootCurve(),
        ),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
    super.initState();
  }

  void animate() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext c, Widget w) {
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: (widget.size - _bubblesSize) / 2.0,
              left: (widget.size - _bubblesSize) / 2.0,
              child: CustomPaint(
                size: Size(_bubblesSize, _bubblesSize),
                painter: _BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  color1: _bubblesColor.dotPrimaryColor,
                  color2: _bubblesColor.dotSecondaryColor,
                  color3: _bubblesColor.dotThirdColorReal,
                  color4: _bubblesColor.dotLastColorReal,
                ),
              ),
            ),
            Positioned(
              top: (widget.size - _circleSize) / 2.0,
              left: (widget.size - _circleSize) / 2.0,
              child: CustomPaint(
                size: Size(_circleSize, _circleSize),
                painter: _CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: _circleColor,
                ),
              ),
            ),
            Transform.scale(
              scale: _scaleAnimation.value == 0.2 ? 1.0 : _scaleAnimation.value,
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({@required this.outerCircleRadiusProgress, @required this.innerCircleRadiusProgress, this.circleColor = const _CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107))}) {
    _circlePaint.style = PaintingStyle.stroke;
  }

  final Paint _circlePaint = Paint();
  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final _CircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    _updateCircleColor();
    final double strokeWidth = outerCircleRadiusProgress * center - (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center), outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  void _updateCircleColor() {
    double colorProgress = _clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = _mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color = Color.lerp(circleColor.start, circleColor.end, colorProgress);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is _CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress || oldDelegate.innerCircleRadiusProgress != innerCircleRadiusProgress || oldDelegate.circleColor != circleColor);
  }
}

class _BubblesPainter extends CustomPainter {
  _BubblesPainter({
    @required this.currentProgress,
    this.bubblesCount = 7,
    this.color1 = const Color(0xFFFFC107),
    this.color2 = const Color(0xFFFF9800),
    this.color3 = const Color(0xFFFF5722),
    this.color4 = const Color(0xFFF44336),
  }) {
    _outerBubblesPositionAngle = 360.0 / bubblesCount;
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }

  final double currentProgress;
  final int bubblesCount;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  double _outerBubblesPositionAngle = 51.42;
  double _centerX = 0.0;
  double _centerY = 0.0;
  final List<Paint> _circlePaints = <Paint>[];

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  double _maxDotSize;

  double _currentRadius1 = 0.0;
  double _currentDotSize1 = 0.0;
  double _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX + _currentRadius1 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius1 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1, _circlePaints[i % _circlePaints.length]);
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 - _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX + _currentRadius2 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius2 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2, _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxOuterDotsRadius * 0.8);
    } else {
      _currentRadius1 = _mapValueFromRangeToRange(currentProgress, 0.3, 1.0, 0.8 * _maxOuterDotsRadius, _maxOuterDotsRadius);
    }
    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = _mapValueFromRangeToRange(currentProgress, 0.7, 1.0, _maxDotSize, 0.0);
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxInnerDotsRadius);
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }
    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.2, 0.5, _maxDotSize, 0.3 * _maxDotSize);
    } else {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, _maxDotSize * 0.3, 0.0);
    }
  }

  void _updateBubblesPaints() {
    final double progress = _clamp(currentProgress, 0.6, 1.0);
    final int alpha = _mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toInt();
    if (currentProgress < 0.5) {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.0, 0.5, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color1, color2, progress).withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color2, color3, progress).withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color3, color4, progress).withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color4, color1, progress).withAlpha(alpha);
    } else {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color2, color3, progress).withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color3, color4, progress).withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color4, color1, progress).withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color1, color2, progress).withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is _BubblesPainter &&
        (oldDelegate.bubblesCount != bubblesCount ||
            oldDelegate.currentProgress != currentProgress ||
            oldDelegate.color1 != color1 ||
            oldDelegate.color2 != color2 ||
            oldDelegate.color3 != color3 ||
            oldDelegate.color4 != color4);
  }
}

class _BubblesColor {
  const _BubblesColor({
    @required this.dotPrimaryColor,
    @required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });

  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color dotThirdColor;
  final Color dotLastColor;

  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class _CircleColor {
  const _CircleColor({
    @required this.start,
    @required this.end,
  });

  final Color start;
  final Color end;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _CircleColor && start == other.start && end == other.end;
  }

  @override
  int get hashCode => hashValues(start, end);
}

class _OvershootCurve extends Curve {
  const _OvershootCurve([this.period = 2.5]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($period)';
  }
}

num _degToRad(num deg) => deg * (math.pi / 180.0);

double _clamp(double value, double low, double high) {
  return math.min(math.max(value, low), high);
}

double _mapValueFromRangeToRange(double value, double fromLow, double fromHigh, double toLow, double toHigh) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}
