import 'package:flutter/material.dart';
import '../utils/resume_data.dart';
import '../models/resume_model.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeData = ResumeDataProvider.getResumeData();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.black26,
      child: Column(
        children: [
          const Text(
            "Education",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 80, height: 4, color: Colors.blue),
          const SizedBox(height: 48),
          ...resumeData.education.map((edu) => 
            EducationCard(
              education: edu,
              isDesktop: isDesktop,
              screenWidth: screenWidth,
            ),
          ).toList(),
        ],
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final Education education;
  final bool isDesktop;
  final double screenWidth;

  const EducationCard({
    super.key,
    required this.education,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDesktop ? 600 : screenWidth * 0.9,
      margin: const EdgeInsets.only(bottom: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  education.degree,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(
                  education.duration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.school,
                color: Colors.blue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                education.institution,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          if (education.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  education.location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
