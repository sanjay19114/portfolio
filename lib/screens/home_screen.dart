import 'package:flutter/material.dart';

// Import widgets
import '../widgets/star_animation.dart';
import '../widgets/navigation.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/certifications_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer.dart';

// Import data and models
import '../models/project_model.dart';
import '../utils/resume_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get global key for each section to use for navigation
    final heroKey = GlobalKey();
    final aboutKey = GlobalKey();
    final skillsKey = GlobalKey();
    final educationKey = GlobalKey();
    final experienceKey = GlobalKey();
    final projectsKey = GlobalKey();
    final certificationsKey = GlobalKey();
    final contactKey = GlobalKey();

    // Project data for projects section - simplified to highlight only key project names
    final List<ProjectModel> projects = [
      ProjectModel(
        title: "Object Detection in Python",
        description: "",
        technologies: ["Python", "TensorFlow", "OpenCV", "YOLO"],
        imageUrl: "assets/images/object_detection.jpg",
        githubUrl: "https://github.com/yourusername/object-detection",
      ),
      ProjectModel(
        title: "Shubharambham Event Planners",
        description: "",
        technologies: ["Flutter", "Firebase", "Custom Animations"],
        imageUrl: "assets/images/event_planning.jpg",
        githubUrl: "https://github.com/yourusername/shubharambham_event_planners",
      ),
      ProjectModel(
        title: "Delivery App",
        description: "",
        technologies: ["Flutter", "Maps API", "Real-time Tracking"],
        imageUrl: "assets/images/delivery.jpg",
        githubUrl: "https://github.com/yourusername/delivery-app",
      ),
      ProjectModel(
        title: "Portfolio Website",
        description: "",
        technologies: ["Flutter Web", "Responsive Design", "Animations"],
        imageUrl: "assets/images/portfolio.jpg",
        githubUrl: "https://github.com/yourusername/portfolio",
      ),
    ];

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
                  onResumePressed: () {
                    // Scroll to education/experience sections
                    scrollToSection(educationKey);
                  },
                ),
                HeroSection(key: heroKey),
                AboutSection(key: aboutKey),
                SkillsSection(key: skillsKey),
                EducationSection(key: educationKey),
                ExperienceSection(key: experienceKey),
                ProjectsSection(key: projectsKey, projects: projects),
                CertificationsSection(key: certificationsKey),
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
