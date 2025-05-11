import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/theme_constants.dart';
import '../utils/animation_utils.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    // Start animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      height: 600,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ThemeConstants.heroSectionGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background grid effect
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
          // Glitch circle effects
          _buildGlitchCircles(),
          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDesktop)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: AnimationUtils.textReveal(
                                text: "Hello, I'm",
                                style: const TextStyle(
                                  fontSize: 24, 
                                  color: ThemeConstants.accentPrimary,
                                  letterSpacing: 2.0,
                                ),
                                duration: const Duration(milliseconds: 800),
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 1.5),
                          child: AnimationUtils.glitchText(
                            text: "Kondaveeti Sanjay",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: ThemeConstants.textPrimary,
                              letterSpacing: 1.5,
                            ),
                            glitchFrequency: const Duration(milliseconds: 5000),
                            maxGlitchOffset: 10,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 2),
                          child: Row(
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      ThemeConstants.accentPrimary,
                                      ThemeConstants.accentSecondary,
                                    ],
                                    stops: const [0.0, 1.0],
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  "Flutter & AI Developer",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Flutter logo animation
                              AnimationUtils.floatingAnimation(
                                height: 10,
                                duration: const Duration(milliseconds: 2500),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 2 * math.pi,
                                      child: const FlutterLogo(size: 32),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 2.5),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ThemeConstants.accentPrimary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              "Building beautiful Flutter applications with cutting-edge AI solutions.",
                              style: TextStyle(fontSize: 18, color: ThemeConstants.textSecondary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 3),
                          child: AnimationUtils.rotate3D(
                            maxRotationX: 5,
                            maxRotationY: 5,
                            child: ElevatedButton(
                              onPressed: () {
                                // Scroll to projects section
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ThemeConstants.primaryButtonStyle,
                              child: const Text(
                                "SEE MY WORK",
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          if (isDesktop)
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(_slideAnimation.value * -3, 0),
                          child: AnimationUtils.rotate3D(
                            maxRotationX: 8,
                            maxRotationY: 8,
                            child: Container(
                              width: 350,
                              height: 350,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    ThemeConstants.accentPrimary.withOpacity(0.7),
                                    ThemeConstants.accentPrimary.withOpacity(0.0),
                                  ],
                                  radius: 0.7,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ThemeConstants.accentPrimary.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ThemeConstants.accentPrimary.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/sanjay.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 150,
                                          color: ThemeConstants.textPrimary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ),
          if (!isDesktop)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * -1),
                          child: AnimationUtils.rotate3D(
                            maxRotationX: 8,
                            maxRotationY: 8,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    ThemeConstants.accentPrimary.withOpacity(0.7),
                                    ThemeConstants.accentPrimary.withOpacity(0.0),
                                  ],
                                  radius: 0.7,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ThemeConstants.accentPrimary.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ThemeConstants.accentPrimary.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/sanjay.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 75,
                                          color: ThemeConstants.textPrimary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: AnimationUtils.glitchText(
                            text: "Kondaveeti Sanjay",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: ThemeConstants.textPrimary,
                              letterSpacing: 1.0,
                            ),
                            glitchFrequency: const Duration(milliseconds: 5000),
                            maxGlitchOffset: 8,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      ThemeConstants.accentPrimary,
                                      ThemeConstants.accentSecondary,
                                    ],
                                    stops: const [0.0, 1.0],
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  "Flutter & AI Developer",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Flutter logo animation
                              AnimationUtils.floatingAnimation(
                                height: 8,
                                duration: const Duration(milliseconds: 2500),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 2 * math.pi,
                                      child: const FlutterLogo(size: 24),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 2),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ThemeConstants.accentPrimary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              "Building beautiful cross-platform apps with Flutter and integrating AI capabilities.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: ThemeConstants.textSecondary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 2.5),
                          child: AnimationUtils.rotate3D(
                            maxRotationX: 5,
                            maxRotationY: 5,
                            child: ElevatedButton(
                              onPressed: () {
                                Scrollable.ensureVisible(
                                  context,
                                  alignment: 0.5,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ThemeConstants.primaryButtonStyle,
                              child: const Text(
                                "SEE MY WORK",
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      )
    );
  }
  
  Widget _buildGlitchCircles() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final random = math.Random(index);
            final size = random.nextDouble() * 300 + 100;
            final left = random.nextDouble() * 0.7;
            final top = random.nextDouble() * 0.7;
            final opacity = random.nextDouble() * 0.1 + 0.05;
            
            return Positioned(
              left: MediaQuery.of(context).size.width * left,
              top: MediaQuery.of(context).size.height * top,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      index % 2 == 0 
                          ? ThemeConstants.accentPrimary.withOpacity(opacity)
                          : ThemeConstants.accentSecondary.withOpacity(opacity),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines with a sci-fi cyberpunk feel
    final gridPaint = Paint()
      ..color = ThemeConstants.accentSecondary.withOpacity(0.03)
      ..strokeWidth = 0.5;
      
    final accentPaint = Paint()
      ..color = ThemeConstants.accentPrimary.withOpacity(0.05)
      ..strokeWidth = 1.0;
      
    final spacing = 30.0;
    final accentSpacing = spacing * 4;
    
    // Draw horizontal grid lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      
      // Draw accent horizontal lines
      if (y % accentSpacing < 0.1) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), accentPaint);
      }
    }
    
    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      
      // Draw accent vertical lines
      if (x % accentSpacing < 0.1) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), accentPaint);
      }
    }
    
    // Draw some random dots for a star-like effect
    final random = math.Random(42); // Fixed seed for consistency
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
      
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      
      canvas.drawCircle(Offset(x, y), radius, dotPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
