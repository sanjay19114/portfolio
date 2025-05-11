class Education {
  final String degree;
  final String institution;
  final String location;
  final String duration;

  Education({
    required this.degree,
    required this.institution,
    required this.location,
    required this.duration,
  });
}

class Experience {
  final String title;
  final String company;
  final String location;
  final String duration;
  final List<String> responsibilities;

  Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.responsibilities,
  });
}

class Certification {
  final String name;
  final String issuer;
  final String date;

  Certification({
    required this.name,
    required this.issuer,
    required this.date,
  });
}

class Skill {
  final String name;
  final String category;

  Skill({
    required this.name,
    required this.category,
  });
}

class ResumeData {
  final String name;
  final String contact;
  final String email;
  final String summary;
  final List<Education> education;
  final List<Experience> experience;
  final List<Certification> certifications;
  final Map<String, List<String>> skills;
  final List<String> languages;

  ResumeData({
    required this.name,
    required this.contact,
    required this.email,
    required this.summary,
    required this.education,
    required this.experience,
    required this.certifications,
    required this.skills,
    required this.languages,
  });
}
