// main.dart - Updated with dark theme, interactive star animations and profile picture

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Import screens
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBvy7y2ipn7XCSgpWvr9Uny048kpwQw-fU",
      authDomain: "sanjay-kondaveeti-portfolio.firebaseapp.com",
      projectId: "sanjay-kondaveeti-portfolio",
      storageBucket: "sanjay-kondaveeti-portfolio.firebasestorage.app",
      messagingSenderId: "1028675392801",
      appId: "1:1028675392801:web:b3221334e43d3a427a5a60",
      measurementId: "G-9ETRJH9MEL",
    ),
  );
  
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  
  // Firebase Analytics instance
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Developer Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        canvasColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Get global key for each section to use for navigation
    final heroKey = GlobalKey();
    final aboutKey = GlobalKey();
    final skillsKey = GlobalKey();
    final projectsKey = GlobalKey();
    final contactKey = GlobalKey();

    return Scaffold(
      body: Stack(
        children: [
          const StarAnimationBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                NavigationHeader(
                  onHomePressed: () {
                    scrollToSection(heroKey);
                  },
                  onAboutPressed: () {
                    scrollToSection(aboutKey);
                  },
                  onSkillsPressed: () {
                    scrollToSection(skillsKey);
                  },
                  onProjectsPressed: () {
                    scrollToSection(projectsKey);
                  },
                  onContactPressed: () {
                    scrollToSection(contactKey);
                  },
                ),
                HeroSection(key: heroKey),
                AboutSection(key: aboutKey),
                SkillsSection(key: skillsKey),
                ProjectsSection(key: projectsKey),
                ContactSection(key: contactKey),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }
}

class StarAnimationBackground extends StatefulWidget {
  const StarAnimationBackground({super.key});

  @override
  State<StarAnimationBackground> createState() =>
      _StarAnimationBackgroundState();
}

class _StarAnimationBackgroundState extends State<StarAnimationBackground>
    with TickerProviderStateMixin {
  late List<StarModel> stars;
  late AnimationController controller;
  Offset mousePosition = Offset.zero;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();

    // Create 100 stars with random positions and speeds
    stars = List.generate(100, (_) => StarModel.random());

    // Create animation controller to drive the animation
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
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
        animation: controller,
        builder: (context, _) {
          return CustomPaint(
            painter: StarPainter(
              stars,
              controller.value,
              mousePosition,
              isHovering,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class StarModel {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double zIndex; // For parallax effect

  StarModel(this.x, this.y, this.size, this.speed, this.opacity, this.zIndex);

  factory StarModel.random() {
    final random = math.Random();
    return StarModel(
      random.nextDouble() * 1.2, // x position (0-1.2)
      random.nextDouble(), // y position (0-1)
      random.nextDouble() * 2 + 1, // size (1-3)
      random.nextDouble() * 0.03 + 0.01, // speed (0.01-0.04)
      random.nextDouble() * 0.5 + 0.5, // opacity (0.5-1.0)
      random.nextDouble() * 0.8 + 0.2, // zIndex (0.2-1.0) for parallax
    );
  }

  StarModel move(double delta) {
    double newX = x - speed * delta;
    if (newX < -0.2) newX = 1.2;
    return StarModel(newX, y, size, speed, opacity, zIndex);
  }

  StarModel moveWithMouse(Offset mousePosition, Size canvasSize) {
    // Calculate distance from mouse
    final mouseX = mousePosition.dx / canvasSize.width;
    final mouseY = mousePosition.dy / canvasSize.height;

    // Direction away from mouse position - stronger effect for stars with higher zIndex (closer to foreground)
    final dx = (x - mouseX) * 0.01 * zIndex;
    final dy = (y - mouseY) * 0.01 * zIndex;

    // Move star position based on mouse
    double newX = x + dx;
    double newY = y + dy;

    // Keep stars within boundaries
    if (newX < 0) newX = 0;
    if (newX > 1.2) newX = 1.2;
    if (newY < 0) newY = 0;
    if (newY > 1) newY = 1;

    return StarModel(newX, newY, size, speed, opacity, zIndex);
  }
}

class StarPainter extends CustomPainter {
  final List<StarModel> stars;
  final double animation;
  final Offset mousePosition;
  final bool isHovering;

  StarPainter(this.stars, this.animation, this.mousePosition, this.isHovering);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final effectiveStars = List<StarModel>.from(stars);

    for (int i = 0; i < effectiveStars.length; i++) {
      // First apply base movement
      var star = effectiveStars[i].move(animation * 20);

      // Then apply mouse-based movement if mouse is hovering
      if (isHovering) {
        star = star.moveWithMouse(mousePosition, size);
      }

      // Add a subtle glow effect to stars
      final glowPaint =
          Paint()
            ..color = Colors.blue.withOpacity(star.opacity * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      // Draw glow
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * 1.5,
        glowPaint,
      );

      // Draw star
      paint.color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * (isHovering ? 1.2 : 1.0), // Slightly larger when hovering
        paint,
      );

      // Draw some larger stars with a cross pattern for extra visual interest
      if (star.size > 2) {
        final point = Offset(star.x * size.width, star.y * size.height);
        final crossSize = star.size * 1.5;

        paint.strokeWidth = star.size * 0.5;

        // Draw cross lines
        canvas.drawLine(
          Offset(point.dx - crossSize, point.dy),
          Offset(point.dx + crossSize, point.dy),
          paint,
        );

        canvas.drawLine(
          Offset(point.dx, point.dy - crossSize),
          Offset(point.dx, point.dy + crossSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.mousePosition != mousePosition ||
      oldDelegate.isHovering != isHovering;
}

class NavigationHeader extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onSkillsPressed;
  final VoidCallback onProjectsPressed;
  final VoidCallback onContactPressed;

  const NavigationHeader({
    super.key,
    required this.onHomePressed,
    required this.onAboutPressed,
    required this.onSkillsPressed,
    required this.onProjectsPressed,
    required this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Kondaveeti Sanjay",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Row(
            children: [
              NavItem(title: "Home", onTap: onHomePressed),
              NavItem(title: "About", onTap: onAboutPressed),
              NavItem(title: "Skills", onTap: onSkillsPressed),
              NavItem(title: "Projects", onTap: onProjectsPressed),
              NavItem(title: "Contact", onTap: onContactPressed),
            ],
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isDesktop)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello, I'm",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Kondaveeti Sanjay",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Flutter Developer",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Building beautiful cross-platform applications with Flutter.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Scroll to projects section
                      final projectsContext = (context
                                  .findAncestorWidgetOfExactType<
                                    PortfolioHome
                                  >()
                              as PortfolioHome)
                          .findProjectsSection(context);
                      if (projectsContext != null) {
                        Scrollable.ensureVisible(
                          projectsContext,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text("See My Work"),
                  ),
                ],
              ),
            ),
          if (isDesktop)
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/sanjay.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.person,
                            size: 150,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          if (!isDesktop)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile_picture.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.person,
                              size: 75,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Kondaveeti Sanjay",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Flutter Developer",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Building beautiful cross-platform applications with Flutter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Find the projects section and scroll to it
                      final projectsSection =
                          context.findRenderObject()?.paintBounds ?? Rect.zero;
                      Scrollable.ensureVisible(
                        context,
                        alignment: .5,
                        duration: const Duration(milliseconds: 800),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("See My Work"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.black12,
      child: Column(
        children: [
          const Text(
            "About Me",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 32),
          const SizedBox(
            width: 800,
            child: Text(
              "I am a passionate Flutter developer with a strong foundation in mobile app development. "
              "I specialize in creating beautiful, performant cross-platform applications using Flutter. "
              "My journey in software development started with Internship and I've since focused on mastering Flutter "
              "and its ecosystem. I enjoy solving complex problems and turning ideas into functional, user-friendly applications.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.black26,
      child: Column(
        children: [
          const Text(
            "My Skills",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 48),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              SkillCard(
                title: "Flutter",
                icon: Icons.flutter_dash,
                description: "Experienced in building cross-platform apps",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
              SkillCard(
                title: "Dart",
                icon: Icons.code,
                description: "Proficient in Dart programming language",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
              SkillCard(
                title: "State Management",
                icon: Icons.architecture,
                description: "Provider, Bloc, GetX, Riverpod",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
              SkillCard(
                title: "UI Design",
                icon: Icons.design_services,
                description: "Creating beautiful user interfaces",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
              SkillCard(
                title: "Firebase",
                icon: Icons.storage,
                description: "Authentication, Firestore, Storage",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
              SkillCard(
                title: "RESTful APIs",
                icon: Icons.api,
                description: "Integration with backend services",
                width: isDesktop ? 250 : screenWidth * 0.8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final double width;

  const SkillCard({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  ProjectsSection({super.key});

  final List<ProjectModel> projects = [
    ProjectModel(
      title: "E-Commerce App",
      description:
          "A full-featured e-commerce application with cart management, payment integration, and user profiles.",
      technologies: ["Flutter", "Provider", "Firebase", "Stripe"],
      imageUrl: "assets/ecommerce.jpg",
      githubUrl: "https://github.com/yourusername/ecommerce",
    ),
    ProjectModel(
      title: "Task Management",
      description:
          "A task management app with beautiful UI, notifications, and cloud sync functionality.",
      technologies: ["Flutter", "Bloc", "Hive", "Firebase"],
      imageUrl: "assets/taskapp.jpg",
      githubUrl: "https://github.com/yourusername/taskmanager",
    ),
    ProjectModel(
      title: "Weather App",
      description:
          "Real-time weather information app with location services and beautiful visualizations.",
      technologies: ["Flutter", "GetX", "RESTful API", "Animations"],
      imageUrl: "assets/weather.jpg",
      githubUrl: "https://github.com/yourusername/weatherapp",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.black12,
      child: Column(
        children: [
          const Text(
            "My Projects",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 48),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children:
                projects
                    .map(
                      (project) => ProjectCard(
                        project: project,
                        width: isDesktop ? 350 : screenWidth * 0.8,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class ProjectModel {
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final String? githubUrl;

  ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    this.githubUrl,
  });
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final double width;

  const ProjectCard({super.key, required this.project, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Colors.grey.shade800,
            ),
            child: Center(
              child: Image.asset(
                project.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    size: 64,
                    color: Colors.grey.shade600,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      project.technologies
                          .map(
                            (tech) => Chip(
                              label: Text(tech),
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Show dialog with project details
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: const Color(0xFF1E1E1E),
                                title: Text(
                                  project.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Technologies Used:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      project.technologies.join(", "),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text("View Details"),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        if (project.githubUrl != null) {
                          final Uri url = Uri.parse(project.githubUrl!);
                          try {
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          } catch (e) {
                            // Show error dialog if URL cannot be opened
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: const Color(0xFF1E1E1E),
                                      title: const Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        "Could not open GitHub link.",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          }
                        }
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text("GitHub"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.black26,
      child: Column(
        children: [
          const Text(
            "Contact Me",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 48),
          Container(
            width: isDesktop ? 500 : screenWidth * 0.9,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Get In Touch",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Message",

                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Form submit handling
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          messageController.text.isEmpty) {
                        // Show error for empty fields
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all the fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Message sent successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Clear form fields
                      nameController.clear();
                      emailController.clear();
                      messageController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Send Message"),
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'k.sanjay19118@gmail.com',
                    );
                    try {
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      }
                    } catch (e) {
                      // Handle error
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "k.sanjay19118@gmail.com",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Hyderabad", style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SocialIcon(
                      icon: Icons.language,
                      onTap: () async {
                        final Uri websiteUri = Uri.parse(
                          'https://yourwebsite.com',
                        );
                        try {
                          if (await canLaunchUrl(websiteUri)) {
                            await launchUrl(websiteUri);
                          }
                        } catch (e) {
                          // Handle error
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    SocialIcon(
                      icon: Icons.code,
                      onTap: () async {
                        final Uri githubUri = Uri.parse(
                          'https://github.com/yourusername',
                        );
                        try {
                          if (await canLaunchUrl(githubUri)) {
                            await launchUrl(githubUri);
                          }
                        } catch (e) {
                          // Handle error
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    SocialIcon(
                      icon: Icons.social_distance,
                      onTap: () async {
                        final Uri linkedinUri = Uri.parse(
                          'https://linkedin.com/in/yourusername',
                        );
                        try {
                          if (await canLaunchUrl(linkedinUri)) {
                            await launchUrl(linkedinUri);
                          }
                        } catch (e) {
                          // Handle error
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    SocialIcon(
                      icon: Icons.email,
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'your.email@example.com',
                        );
                        try {
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          }
                        } catch (e) {
                          // Handle error
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SocialIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: const Color(0xFF0A192F),
      child: const Center(
        child: Text(
          "© 2025 Kondaveeti Sanjay. All rights reserved.",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

extension PortfolioHomeExtension on PortfolioHome {
  BuildContext? findProjectsSection(BuildContext context) {
    BuildContext? projectsContext;

    void visitor(Element element) {
      if (element.widget is ProjectsSection) {
        projectsContext = element;
        return;
      }
      element.visitChildren(visitor);
    }

    (context as Element).visitChildren(visitor);
    return projectsContext;
  }
}
