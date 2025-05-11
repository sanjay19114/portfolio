import '../models/resume_model.dart';

class ResumeDataProvider {
  static ResumeData getResumeData() {
    return ResumeData(
      name: "Kondaveeti Sanjay",
      contact: "(+91)8309723837",
      email: "k.sanjay9718@gmail.com",
      summary: "Versatile Flutter Developer and AI/ML Engineer with hands-on experience in mobile app development, "
          "cross-platform solutions, object detection, and cloud integration. Skilled in Flutter, Dart, Python, "
          "TensorFlow, and various state management techniques. Certified in Flutter development, AWS, and machine learning. "
          "Seeking to leverage technical expertise in creating beautiful, performant mobile applications and "
          "innovative AI solutions.",
      education: [
        Education(
          degree: "Bachelor of Technology in Artificial Intelligence and Data Science",
          institution: "KL University",
          location: "Hyderabad",
          duration: "2020 - 2024",
        ),
        Education(
          degree: "Intermediate",
          institution: "Sri Chaitanya Junior College",
          location: "",
          duration: "2018 - 2020",
        ),
        Education(
          degree: "Secondary Education",
          institution: "Sri Chaitanya Techno School",
          location: "",
          duration: "2018",
        ),
      ],
      experience: [
        Experience(
          title: "Machine Learning Engineer",
          company: "Techcora Corporation",
          location: "Chennai",
          duration: "6-Month Internship",
          responsibilities: [
            "Developed and implemented machine learning models to detect objects in real-time video streams and images.",
            "Utilized computer vision techniques and tools such as OpenCV and TensorFlow to preprocess and analyze images and videos.",
            "Collaborated with a team of data scientists and engineers to improve model accuracy and efficiency.",
            "Conducted data collection and annotation to create robust training datasets.",
            "Evaluated model performance using accuracy, recall, and F1-score, achieving 92% accuracy in target detection.",
            "Implemented optimized ML pipelines for production environments with scalable architecture.",
            "Presented technical findings to stakeholders and documented model architectures and results.",
          ],
        ),
        Experience(
          title: "Flutter Developer",
          company: "Surfboard Payments",
          location: "Remote",
          duration: "2-Month Internship",
          responsibilities: [
            "Developed responsive payment processing interfaces using Flutter for cross-platform compatibility.",
            "Implemented secure payment gateway integrations with industry standard encryption protocols.",
            "Created custom widgets for payment cards, transaction histories, and user authentication flows.",
            "Collaborated with backend engineers to design and consume RESTful APIs for financial transactions.",
            "Implemented state management using Bloc pattern for complex finance application workflows.",
            "Conducted thorough testing to ensure payment reliability and security compliance.",
            "Optimized app performance for handling sensitive financial data with minimal resource usage.",
          ],
        ),
        Experience(
          title: "Freelance Flutter Developer",
          company: "Self-employed",
          location: "Remote",
          duration: "2022 - Present",
          responsibilities: [
            "Developed custom Flutter applications for multiple clients across e-commerce, education, and event management sectors.",
            "Implemented complex UI components including animations, custom charts, and interactive maps.",
            "Created reusable Flutter packages and plugins to enhance development efficiency.",
            "Integrated payment gateways including Stripe, PayPal, and Razorpay for seamless transactions.",
            "Utilized Flutter's latest features including navigation 2.0 and null safety to create robust applications.",
            "Applied test-driven development practices with unit, widget, and integration tests.",
            "Maintained and updated existing Flutter applications to newer SDK versions and features.",
          ],
        ),
      ],
      certifications: [
        Certification(
          name: "AWS Certified Cloud Practitioner",
          issuer: "AWS",
          date: "2022",
        ),
        Certification(
          name: "Pega Certified System Architect (CSA)",
          issuer: "Pegasystems",
          date: "2023",
        ),
        Certification(
          name: "Pega Certified Senior System Architect (CSSA)",
          issuer: "Pegasystems",
          date: "2023",
        ),
        Certification(
          name: "Python for Beginners Certification",
          issuer: "Udemy",
          date: "2021",
        ),
      ],
      skills: {
        "Programming Languages": ["Dart", "Python", "JavaScript", "HTML", "CSS", "SQL"],
        "Mobile Development": ["Flutter", "UI/UX Design", "Responsive Layout", "Cross-Platform Development", "Native Integration"],
        "State Management": ["Provider", "Bloc", "Riverpod", "GetX", "Redux"],
        "Flutter Ecosystem": ["Flutter Widgets", "Custom Animations", "Flutter Navigation", "Platform Channels", "Flutter Web", "Flutter Desktop"],
        "Frameworks & Libraries": ["Flutter", "Firebase", "Django REST Framework", "PyTorch", "Keras", "OpenCV", "Scikit-learn"],
        "Tools & Platforms": ["Android Studio", "VS Code", "Xcode", "Firebase", "Postman", "Google Play Console", "App Store Connect", "Flutterflow", "PyCharm", "Google Cloud Platform", "Jupyter Notebook", "GitHub Actions"],
        "Backend & Storage": ["Firebase Authentication", "Firestore", "Cloud Functions", "REST APIs", "GraphQL", "SQLite", "Hive"],
        "API Development": ["RESTful APIs", "GraphQL", "CRUD", "SQL Integration", "HTTP Connectors"],
        "ML & AI": ["TensorFlow", "TensorFlow Lite", "ML Kit", "Computer Vision", "Natural Language Processing"],
        "Soft Skills": ["Team Collaboration", "Effective Communication", "Time Management", "Problem-Solving", "Client Management"],
      },
      languages: ["English", "Telugu", "Hindi"],
    );
  }
}
