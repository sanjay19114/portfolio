import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme_constants.dart';
import '../utils/animation_utils.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ThemeConstants.contactSectionGradient,
        ),
      ),
      child: Column(
        children: [
          AnimationUtils.glitchText(
            text: "Get In Touch",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: ThemeConstants.accentSecondary),
          const SizedBox(height: 32),
          SizedBox(
            width: 600,
            child: AnimationUtils.textReveal(
              text: "Feel free to reach out if you're looking for a developer, have a question, or just want to connect.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
                color: ThemeConstants.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            width: isDesktop ? 600 : screenWidth * 0.9,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: ThemeConstants.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeConstants.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ContactItem(
                  icon: Icons.email,
                  title: "Email",
                  subtitle: "k.sanjay19118@gmail.com",
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
                ),
                const SizedBox(height: 24),
                ContactItem(
                  icon: Icons.phone,
                  title: "Phone",
                  subtitle: "(+91)8309723837",
                  onTap: () async {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: '+918309723837',
                    );
                    try {
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    } catch (e) {
                      // Handle error
                    }
                  },
                ),
                const SizedBox(height: 24),
                ContactItem(
                  icon: Icons.location_on,
                  title: "Location",
                  subtitle: "Hyderabad, India",
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                AnimationUtils.glitchText(
                  text: "Connect With Me",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      icon: Icons.code,
                      tooltip: "GitHub",
                      onTap: () async {
                        final Uri githubUri = Uri.parse(
                          'https://github.com/sanjay19114',
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
                    const SizedBox(width: 24),
                    SocialIcon(
                      icon: Icons.person,
                      tooltip: "LinkedIn",
                      onTap: () async {
                        final Uri linkedinUri = Uri.parse(
                          'https://www.linkedin.com/in/kondaveeti-sanjay/',
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
                    const SizedBox(width: 24),
                    SocialIcon(
                      icon: Icons.description,
                      tooltip: "Resume",
                      onTap: () async {
                        final Uri resumeUri = Uri.parse(
                          'https://drive.google.com/file/d/1o6tktxFioFKMOesxjrg7zjiU57MpTAVr/view?usp=drive_link',
                        );
                        try {
                          if (await canLaunchUrl(resumeUri)) {
                            await launchUrl(resumeUri);
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

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ContactItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const SocialIcon({super.key, required this.icon, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeConstants.accentSecondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: ThemeConstants.accentSecondary, size: 24),
    );
    
    return tooltip != null
      ? Tooltip(
          message: tooltip!,
          child: InkWell(
            onTap: onTap,
            child: iconWidget,
          ),
        )
      : InkWell(
          onTap: onTap,
          child: iconWidget,
        );
  }
}
