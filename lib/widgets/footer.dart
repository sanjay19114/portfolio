import 'package:flutter/material.dart';

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
