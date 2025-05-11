import 'package:flutter/material.dart';
import '../utils/resume_data.dart';
import '../utils/theme_constants.dart';
import '../utils/animation_utils.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumeData = ResumeDataProvider.getResumeData();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ThemeConstants.aboutSectionGradient,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimationUtils.glitchText(
                text: "About Me",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              // Flutter logo with animation
              ScaleTransition(
                scale: _animation,
                child: const FlutterLogo(size: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 32),
          SizedBox(
            width: isDesktop ? 800 : screenWidth * 0.9,
            child: AnimationUtils.textReveal(
              text: resumeData.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
                color: ThemeConstants.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Flutter strengths section
          SizedBox(
            width: isDesktop ? 800 : screenWidth * 0.9,
            child: Column(
              children: [
                AnimationUtils.glitchText(
                  text: "Flutter Expertise",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.accentSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFlutterFeature(
                      icon: Icons.devices,
                      title: "Cross-Platform",
                      description: "Building apps for Android, iOS, Web & Desktop",
                    ),
                    _buildFlutterFeature(
                      icon: Icons.speed,
                      title: "High Performance",
                      description: "Creating highly performant, beautiful UIs",
                    ),
                    _buildFlutterFeature(
                      icon: Icons.architecture,
                      title: "Architecture",
                      description: "Expertise in Bloc, Provider, and Riverpod",
                    ),
                    _buildFlutterFeature(
                      icon: Icons.animation,
                      title: "Animations",
                      description: "Custom animations and transitions",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Wrap contact info in a responsive layout
          isDesktop 
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContactInfoItem(
                  icon: Icons.email,
                  text: resumeData.email,
                ),
                const SizedBox(width: 24),
                ContactInfoItem(
                  icon: Icons.phone,
                  text: resumeData.contact,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContactInfoItem(
                  icon: Icons.email,
                  text: resumeData.email,
                ),
                const SizedBox(height: 16),
                ContactInfoItem(
                  icon: Icons.phone,
                  text: resumeData.contact,
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildFlutterFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return AnimationUtils.rotate3D(
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeConstants.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeConstants.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ThemeConstants.accentSecondary, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: ThemeConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth > 800 ? 300 : screenWidth * 0.8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ThemeConstants.accentSecondary, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: ThemeConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
