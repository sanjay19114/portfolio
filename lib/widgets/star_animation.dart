import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleModel {
  double x;
  double y;
  double size;
  double speed;
  double direction;
  Color color;
  double opacity;
  double rotation;
  double rotationSpeed;
  double acceleration;
  double maxSpeed;
  late double initialX; // Will be set in constructor
  late double initialY; // Will be set in constructor
  double hoverStrength;
  
  // Keep track of time for oscillation effects
  double time = 0;
  
  // Shape type (0 = circle, 1 = square, 2 = triangle, 3 = line)
  final int shape;

  ParticleModel({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
    required this.color,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
    required this.acceleration, 
    required this.maxSpeed,
    required this.hoverStrength,
  }) {
    initialX = x;
    initialY = y;
  }

  factory ParticleModel.random(Size screenSize) {
    final random = math.Random();
    
    // Generate colors in a pleasing palette
    final List<Color> colorPalette = [
      Color(0xFF007BFF), // Blue
      Color(0xFF6610F2), // Indigo
      Color(0xFF6F42C1), // Purple
      Color(0xFF17A2B8), // Cyan
      Color(0xFF20C997), // Teal
    ];
    
    // Calculate size based on screen dimensions to ensure it scales well
    double particleSize = math.min(screenSize.width, screenSize.height) * 
                          (random.nextDouble() * 0.01 + 0.002);

    return ParticleModel(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: particleSize,
      speed: random.nextDouble() * 0.0005 + 0.0001,
      direction: random.nextDouble() * 2 * math.pi,
      color: colorPalette[random.nextInt(colorPalette.length)],
      opacity: random.nextDouble() * 0.4 + 0.1,
      rotation: random.nextDouble() * 2 * math.pi,
      rotationSpeed: (random.nextDouble() - 0.5) * 0.001,
      shape: random.nextInt(4),
      acceleration: random.nextDouble() * 0.00001,
      maxSpeed: random.nextDouble() * 0.005 + 0.001,
      hoverStrength: random.nextDouble() * 0.8 + 0.2,
    );
  }

  void update(double deltaTime) {
    time += deltaTime * 0.001;
    
    // Apply some oscillation to create organic movement
    double oscillationX = math.sin(time * (0.1 + speed * 100)) * 0.001;
    double oscillationY = math.cos(time * (0.1 + speed * 100)) * 0.001;
    
    // Update position with direction and speed
    x += math.cos(direction) * speed + oscillationX;
    y += math.sin(direction) * speed + oscillationY;
    
    // Apply rotation
    rotation += rotationSpeed * deltaTime;
    
    // Apply gentle acceleration up to max speed
    speed = (speed + acceleration * deltaTime).clamp(0, maxSpeed);
    
    // Soft bounce off edges
    if (x < 0 || x > 1) {
      direction = math.pi - direction;
      x = x.clamp(0, 1);
    }
    if (y < 0 || y > 1) {
      direction = -direction;
      y = y.clamp(0, 1);
    }
  }
  
  void interactWithMouse(Offset mousePosition, Size canvasSize, bool isHovering) {
    if (!isHovering) return;
    
    // Convert mouse position to relative coordinates (0-1)
    final relativeMouseX = mousePosition.dx / canvasSize.width;
    final relativeMouseY = mousePosition.dy / canvasSize.height;
    
    // Calculate distance and direction to mouse
    final dx = x - relativeMouseX;
    final dy = y - relativeMouseY;
    final distanceSquared = dx * dx + dy * dy;
    
    if (distanceSquared < 0.04) { // Interaction radius
      final distance = math.sqrt(distanceSquared);
      final interactionStrength = (0.04 - distance) * hoverStrength * 0.01;
      
      // Calculate angle from mouse to particle
      final angle = math.atan2(dy, dx);
      
      // Apply force away from mouse position
      x += math.cos(angle) * interactionStrength;
      y += math.sin(angle) * interactionStrength;
      
      // Slightly increase opacity and size for particles near mouse
      opacity = (opacity + 0.1 * interactionStrength).clamp(0.1, 0.9);
      size = size * (1 + 0.2 * interactionStrength);
    } else {
      // Gradually return to original state
      opacity = opacity * 0.98 + 0.02 * (opacity - 0.1);
      size = size * 0.98 + 0.02 * (size / 1.2);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final Offset mousePosition;
  final bool isHovering;
  final double animationValue;
  final double backgroundAnimationValue;
  final Size screenSize;

  ParticlePainter({
    required this.particles,
    required this.mousePosition,
    required this.isHovering,
    required this.animationValue,
    required this.backgroundAnimationValue,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate slow-moving background position based on animation values
    final dx = math.sin(backgroundAnimationValue * math.pi) * 0.1;
    final dy = math.cos(backgroundAnimationValue * math.pi * 0.7) * 0.1;
    
    // Create a deep gradient background with modern colors
    final backgroundGradient = RadialGradient(
      center: Alignment(dx, dy),
      radius: 1.5,
      colors: [
        const Color(0xFF0D1117), // GitHub dark
        const Color(0xFF0A192F), // Dark blue
        const Color(0xFF06101F), // Deeper blue
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    
    // Add secondary gradient overlay for depth
    final overlayGradient = LinearGradient(
      begin: Alignment(dx - 0.3, dy - 0.3),
      end: Alignment(dx + 0.3, dy + 0.3),
      colors: [
        const Color(0xFF0097A7).withOpacity(0.05), // Teal
        const Color(0xFF512DA8).withOpacity(0.05), // Deep Purple
      ],
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw base background
    canvas.drawRect(
      rect,
      Paint()..shader = backgroundGradient.createShader(rect),
    );
    
    // Draw overlay gradient
    canvas.drawRect(
      rect,
      Paint()..shader = overlayGradient.createShader(rect),
    );
    
    // Draw subtle glow points for depth
    final glowCount = math.min(5, (size.width / 300).floor());
    for (int i = 0; i < glowCount; i++) {
      final t = i / glowCount;
      final glowX = size.width * (0.1 + 0.8 * math.sin(backgroundAnimationValue * math.pi + t * math.pi * 2));
      final glowY = size.height * (0.1 + 0.8 * math.cos(backgroundAnimationValue * math.pi * 0.7 + t * math.pi * 2));
      
      final glowSize = math.min(size.width, size.height) * (0.15 + 0.05 * i);
      
      // Create subtle gradient glow
      final glowGradient = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Color.lerp(const Color(0xFF007BFF), const Color(0xFF512DA8), t)!.withOpacity(0.05),
          Color.lerp(const Color(0xFF007BFF), const Color(0xFF512DA8), t)!.withOpacity(0.0),
        ],
      );
      
      final glowRect = Rect.fromCenter(
        center: Offset(glowX, glowY),
        width: glowSize,
        height: glowSize,
      );
      
      canvas.drawCircle(
        Offset(glowX, glowY),
        glowSize / 2,
        Paint()..shader = glowGradient.createShader(glowRect),
      );
    }
    
    // Add subtle grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 0.5;
    
    final gridSpacing = math.max(size.width, size.height) / 20;
    final offsetX = (backgroundAnimationValue * gridSpacing * 2) % gridSpacing;
    final offsetY = (backgroundAnimationValue * gridSpacing * 1.5) % gridSpacing;
    
    // Draw horizontal grid lines
    for (double y = offsetY; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    // Draw vertical grid lines
    for (double x = offsetX; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Update and draw each particle
    for (final particle in particles) {
      // Update particle state
      particle.update(16); // Assuming 60fps (16ms per frame)
      
      // Handle mouse interaction
      if (isHovering) {
        particle.interactWithMouse(mousePosition, size, isHovering);
      }

      // Calculate screen coordinates
      final screenX = particle.x * size.width;
      final screenY = particle.y * size.height;
      
      // Create paint for particle
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      // Save canvas state for rotation
      canvas.save();
      canvas.translate(screenX, screenY);
      canvas.rotate(particle.rotation);
      
      // Draw particle based on shape type
      switch (particle.shape) {
        case 0: // Circle
          canvas.drawCircle(Offset.zero, particle.size, paint);
          break;
          
        case 1: // Square
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size * 1.8,
              height: particle.size * 1.8,
            ),
            paint,
          );
          break;
          
        case 2: // Triangle
          final path = Path();
          final s = particle.size * 2;
          path.moveTo(0, -s);
          path.lineTo(s * 0.866, s * 0.5); // cos(60°), sin(60°)
          path.lineTo(-s * 0.866, s * 0.5);
          path.close();
          canvas.drawPath(path, paint);
          break;
          
        case 3: // Line
          canvas.drawLine(
            Offset(-particle.size * 1.5, 0),
            Offset(particle.size * 1.5, 0),
            paint..strokeWidth = particle.size * 0.5,
          );
          break;
      }
      
      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || 
           oldDelegate.backgroundAnimationValue != backgroundAnimationValue ||
           oldDelegate.isHovering != isHovering;
  }
}

class StarAnimationBackground extends StatefulWidget {
  const StarAnimationBackground({super.key});

  @override
  State<StarAnimationBackground> createState() => _StarAnimationBackgroundState();
}

class _StarAnimationBackgroundState extends State<StarAnimationBackground>
    with TickerProviderStateMixin {
  late List<ParticleModel> particles;
  late AnimationController controller;
  late AnimationController backgroundController;
  Offset mousePosition = Offset.zero;
  bool isHovering = false;
  Size screenSize = Size.zero;

  @override
  void initState() {
    super.initState();

    // Initialize with empty list, will populate in didChangeDependencies
    particles = [];

    // Create animation controller for particles
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // Create a slower controller for the background movement
    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120), // Much slower (2 minutes)
    )..repeat();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get screen size to calculate appropriate particle sizes
    screenSize = MediaQuery.of(context).size;
    
    // Create particles with sizes appropriate to screen dimensions
    // Only recreate if we don't already have particles or if screen size changed dramatically
    if (particles.isEmpty) {
      // Create more particles for larger screens, fewer for smaller ones
      final particleCount = math.max(50, math.min(150, (screenSize.width / 15).floor()));
      particles = List.generate(particleCount, (_) => ParticleModel.random(screenSize));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          mousePosition = event.localPosition;
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([controller, backgroundController]),
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              particles: particles,
              mousePosition: mousePosition,
              isHovering: isHovering,
              animationValue: controller.value,
              backgroundAnimationValue: backgroundController.value,
              screenSize: screenSize,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
