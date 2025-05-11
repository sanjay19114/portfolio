import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animation utilities for creating advanced effects
class AnimationUtils {
  /// Creates a staggered fade-in slide animation that triggers based on scroll position
  static Widget scrollFadeSlide({
    required BuildContext context,
    required Widget child,
    required ScrollController scrollController,
    double startOffset = 0.0,
    double endOffset = 0.3,
    Duration duration = const Duration(milliseconds: 800),
    Offset slideOffset = const Offset(0, 50),
    Curve curve = Curves.easeOut,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final scrollPosition = scrollController.position.pixels;
        final viewportHeight = MediaQuery.of(context).size.height;
        final widgetPosition = context.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;
        
        // Calculate how far the widget is from the viewport's bottom
        final relativePosition = (widgetPosition - scrollPosition) / viewportHeight;
        
        // Animation progress based on scroll position
        final animationProgress = relativePosition <= startOffset
            ? 1.0
            : relativePosition >= endOffset
                ? 0.0
                : 1.0 - (relativePosition - startOffset) / (endOffset - startOffset);
        
        return AnimatedOpacity(
          opacity: animationProgress.clamp(0.0, 1.0),
          duration: duration,
          curve: curve,
          child: AnimatedSlide(
            offset: Offset(
              slideOffset.dx * (1 - animationProgress.clamp(0.0, 1.0)), 
              slideOffset.dy * (1 - animationProgress.clamp(0.0, 1.0))
            ),
            duration: duration,
            curve: curve,
            child: child,
          ),
        );
      },
    );
  }
  
  /// Creates a 3D tilt effect based on mouse position
  static Widget mouseTrackingTilt({
    required Widget child,
    double maxTiltAngle = 10.0,
    double perspective = 0.001,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Values for tilt angles in radians
        double tiltX = 0;
        double tiltY = 0;
        
        return MouseRegion(
          onHover: (event) {
            // Get the widget's size and relative mouse position
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Size size = box.size;
            final Offset position = box.globalToLocal(event.position);
            
            // Calculate tilt angles based on position relative to center
            setState(() {
              tiltY = ((position.dx / size.width) - 0.5) * 2 * maxTiltAngle * (math.pi / 180);
              tiltX = ((position.dy / size.height) - 0.5) * -2 * maxTiltAngle * (math.pi / 180);
            });
          },
          onExit: (event) {
            // Reset tilt when mouse leaves
            setState(() {
              tiltX = 0;
              tiltY = 0;
            });
          },
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, perspective) // Add perspective
              ..rotateX(tiltX)
              ..rotateY(tiltY),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
  
  /// Creates a parallax scrolling effect
  static Widget parallaxScroll({
    required Widget child,
    required ScrollController scrollController,
    double parallaxFactor = 0.5,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final scrollPosition = scrollController.position.pixels;
        return Transform.translate(
          offset: Offset(0, scrollPosition * parallaxFactor),
          child: child,
        );
      },
    );
  }
  
  /// Creates a reveal animation that shows content character by character
  static Widget textReveal({
    required String text,
    TextStyle? style,
    Duration duration = const Duration(milliseconds: 2000),
    Curve curve = Curves.easeOut,
    TextAlign? textAlign,
  }) {
    return _TextRevealAnimation(
      text: text,
      style: style,
      duration: duration,
      curve: curve,
      textAlign: textAlign,
    );
  }
  
  /// Creates a glitch text effect
  static Widget glitchText({
    required String text,
    TextStyle? style,
    Duration glitchFrequency = const Duration(milliseconds: 3000),
    Duration glitchDuration = const Duration(milliseconds: 500),
    int maxGlitchOffset = 5,
    TextAlign? textAlign,
  }) {
    return _GlitchTextAnimation(
      text: text,
      style: style,
      glitchFrequency: glitchFrequency,
      glitchDuration: glitchDuration,
      maxGlitchOffset: maxGlitchOffset,
      textAlign: textAlign,
    );
  }
  
  /// Creates a 3D rotation effect for cards or containers
  static Widget rotate3D({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    double maxRotationX = 10.0,
    double maxRotationY = 10.0,
  }) {
    return _Rotate3DAnimation(
      child: child,
      duration: duration,
      maxRotationX: maxRotationX,
      maxRotationY: maxRotationY,
    );
  }
  
  /// Creates a floating animation that simulates a hovering effect
  static Widget floatingAnimation({
    required Widget child,
    double height = 10.0,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return _FloatingAnimation(
      child: child,
      height: height,
      duration: duration,
    );
  }
}

/// Text reveal animation that shows text character by character
class _TextRevealAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final TextAlign? textAlign;

  const _TextRevealAnimation({
    required this.text,
    this.style,
    required this.duration,
    required this.curve,
    this.textAlign,
  });

  @override
  State<_TextRevealAnimation> createState() => _TextRevealAnimationState();
}

class _TextRevealAnimationState extends State<_TextRevealAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
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
      animation: _animation,
      builder: (context, child) {
        final visibleCharacters = (widget.text.length * _animation.value).round();
        return Text(
          widget.text.substring(0, visibleCharacters),
          style: widget.style,
          textAlign: widget.textAlign,
        );
      },
    );
  }
}

/// Glitch text animation for cyberpunk-style effects
class _GlitchTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration glitchFrequency;
  final Duration glitchDuration;
  final int maxGlitchOffset;
  final TextAlign? textAlign;

  const _GlitchTextAnimation({
    required this.text,
    this.style,
    required this.glitchFrequency,
    required this.glitchDuration,
    required this.maxGlitchOffset,
    this.textAlign,
  });

  @override
  State<_GlitchTextAnimation> createState() => _GlitchTextAnimationState();
}

class _GlitchTextAnimationState extends State<_GlitchTextAnimation> {
  final math.Random _random = math.Random();
  String _displayedText = '';
  bool _isGlitching = false;

  @override
  void initState() {
    super.initState();
    _displayedText = widget.text;
    _scheduleNextGlitch();
  }

  void _scheduleNextGlitch() {
    Future.delayed(widget.glitchFrequency, () {
      if (mounted) {
        _startGlitch();
      }
    });
  }

  void _startGlitch() {
    setState(() {
      _isGlitching = true;
      _updateGlitchText();
    });

    Future.delayed(widget.glitchDuration, () {
      if (mounted) {
        setState(() {
          _isGlitching = false;
          _displayedText = widget.text;
        });
        _scheduleNextGlitch();
      }
    });
  }

  void _updateGlitchText() {
    if (!_isGlitching) return;

    setState(() {
      // Create a glitched version of the text
      _displayedText = String.fromCharCodes(
        widget.text.codeUnits.map((codeUnit) {
          if (_random.nextDouble() < 0.3) { // 30% chance to glitch a character
            return codeUnit + _random.nextInt(widget.maxGlitchOffset * 2) - widget.maxGlitchOffset;
          }
          return codeUnit;
        }),
      );
    });

    // Continue glitching during the glitch duration
    if (_isGlitching) {
      Future.delayed(const Duration(milliseconds: 50), _updateGlitchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

/// 3D rotation animation for cards and containers
class _Rotate3DAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double maxRotationX;
  final double maxRotationY;

  const _Rotate3DAnimation({
    required this.child,
    required this.duration,
    required this.maxRotationX,
    required this.maxRotationY,
  });

  @override
  State<_Rotate3DAnimation> createState() => _Rotate3DAnimationState();
}

class _Rotate3DAnimationState extends State<_Rotate3DAnimation> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Size size = box.size;
        final Offset position = box.globalToLocal(event.position);

        setState(() {
          // Calculate rotation based on mouse position relative to center
          _rotationY = ((position.dx / size.width) - 0.5) * 2 * widget.maxRotationY;
          _rotationX = ((position.dy / size.height) - 0.5) * -2 * widget.maxRotationX;
        });
      },
      onExit: (event) {
        setState(() {
          _rotationX = 0.0;
          _rotationY = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: widget.duration,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_rotationX * (math.pi / 180))
          ..rotateY(_rotationY * (math.pi / 180)),
        child: widget.child,
      ),
    );
  }
}

/// Floating animation for hovering elements
class _FloatingAnimation extends StatefulWidget {
  final Widget child;
  final double height;
  final Duration duration;

  const _FloatingAnimation({
    required this.child,
    required this.height,
    required this.duration,
  });

  @override
  State<_FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<_FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: -widget.height / 2,
      end: widget.height / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}
