import 'package:flutter/material.dart';
import '../utils/resume_data.dart';
import '../utils/theme_constants.dart';
import '../utils/animation_utils.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
          colors: ThemeConstants.skillsSectionGradient,
        ),
      ),
      child: Column(
        children: [
          AnimationUtils.glitchText(
            text: "My Skills",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: ThemeConstants.accentSecondary),
          const SizedBox(height: 48),
          // Display programming languages
          _buildSkillCategory(
            context: context,
            title: "Programming Languages",
            skills: resumeData.skills["Programming Languages"] ?? [],
            isDesktop: isDesktop,
            screenWidth: screenWidth,
            icon: Icons.code,
          ),
          const SizedBox(height: 40),
          // Display frameworks & libraries
          _buildSkillCategory(
            context: context,
            title: "Frameworks & Libraries",
            skills: resumeData.skills["Frameworks & Libraries"] ?? [],
            isDesktop: isDesktop,
            screenWidth: screenWidth,
            icon: Icons.architecture,
          ),
          const SizedBox(height: 40),
          // Display tools & platforms
          _buildSkillCategory(
            context: context,
            title: "Tools & Platforms",
            skills: resumeData.skills["Tools & Platforms"] ?? [],
            isDesktop: isDesktop,
            screenWidth: screenWidth,
            icon: Icons.build,
          ),
          const SizedBox(height: 40),
          // Display API Development
          _buildSkillCategory(
            context: context,
            title: "API Development",
            skills: resumeData.skills["API Development"] ?? [],
            isDesktop: isDesktop,
            screenWidth: screenWidth,
            icon: Icons.api,
          ),
          const SizedBox(height: 40),
          // Display Soft Skills
          _buildSkillCategory(
            context: context,
            title: "Soft Skills",
            skills: resumeData.skills["Soft Skills"] ?? [],
            isDesktop: isDesktop,
            screenWidth: screenWidth,
            icon: Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory({
    required BuildContext context,
    required String title,
    required List<String> skills,
    required bool isDesktop,
    required double screenWidth,
    required IconData icon,
  }) {
    return Column(
      children: [
        AnimationUtils.floatingAnimation(
          height: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: ThemeConstants.accentSecondary, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: skills
              .map(
                (skill) => SkillChip(
                  label: skill,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationUtils.rotate3D(
      maxRotationX: 5.0,
      maxRotationY: 5.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeConstants.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ThemeConstants.cardBorder),
        ),
      child: Text(
        label,
        style: const TextStyle(
          color: ThemeConstants.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    );
  }
}
