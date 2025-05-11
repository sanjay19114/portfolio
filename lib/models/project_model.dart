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
