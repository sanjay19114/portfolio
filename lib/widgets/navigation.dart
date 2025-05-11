import 'package:flutter/material.dart';

class NavigationHeader extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onSkillsPressed;
  final VoidCallback onProjectsPressed;
  final VoidCallback onContactPressed;
  final VoidCallback? onResumePressed;

  const NavigationHeader({
    super.key,
    required this.onHomePressed,
    required this.onAboutPressed,
    required this.onSkillsPressed,
    required this.onProjectsPressed,
    required this.onContactPressed,
    this.onResumePressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.black.withOpacity(0.7),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Portfolio",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    NavItem(
                      title: "Home",
                      onPressed: onHomePressed,
                    ),
                    const SizedBox(width: 24),
                    NavItem(
                      title: "About",
                      onPressed: onAboutPressed,
                    ),
                    const SizedBox(width: 24),
                    NavItem(
                      title: "Skills",
                      onPressed: onSkillsPressed,
                    ),
                    const SizedBox(width: 24),
                    NavItem(
                      title: "Projects",
                      onPressed: onProjectsPressed,
                    ),
                    const SizedBox(width: 24),
                    NavItem(
                      title: "Contact",
                      onPressed: onContactPressed,
                    ),
                    if (onResumePressed != null) ...[
                      const SizedBox(width: 24),
                      NavItem(
                        title: "Resume",
                        onPressed: onResumePressed!,
                      ),
                    ],
                  ],
                ),
              ],
            )
          : Column(
              children: [
                const Text(
                  "Portfolio",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavItem(
                        title: "Home",
                        onPressed: onHomePressed,
                      ),
                      const SizedBox(width: 16),
                      NavItem(
                        title: "About",
                        onPressed: onAboutPressed,
                      ),
                      const SizedBox(width: 16),
                      NavItem(
                        title: "Skills",
                        onPressed: onSkillsPressed,
                      ),
                      const SizedBox(width: 16),
                      NavItem(
                        title: "Projects",
                        onPressed: onProjectsPressed,
                      ),
                      const SizedBox(width: 16),
                      NavItem(
                        title: "Contact",
                        onPressed: onContactPressed,
                      ),
                      if (onResumePressed != null) ...[
                        const SizedBox(width: 16),
                        NavItem(
                          title: "Resume",
                          onPressed: onResumePressed!,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const NavItem({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
