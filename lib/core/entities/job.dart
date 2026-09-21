class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String jobType; // Full-time, Internship, Part-time, Remote...
  final String salary; // display string, e.g. "₹25,000/mo" or "Not disclosed"
  final String logoUrl;
  final String description;
  final List<String> skills;
  final String experience;
  final String applyUrl;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.logoUrl,
    required this.description,
    required this.skills,
    required this.experience,
    required this.applyUrl,
  });
}

/// Temporary mock data so these screens run standalone before
/// job_api_service.dart / job_provider.dart are wired in.
final List<Job> mockJobs = List.generate(10, (i) {
  const types = ['Full-time', 'Internship', 'Part-time', 'Remote'];
  return Job(
    id: 'job_$i',
    title: [
      'Flutter Developer',
      'Backend Engineer',
      'UI/UX Designer',
      'Product Manager',
      'QA Engineer',
    ][i % 5],
    company: [
      'Nimbus Labs',
      'Coral Tech',
      'Vertex Studio',
      'Harbor Systems',
      'Pixel Forge',
    ][i % 5],
    location: ['Remote', 'Kochi, IN', 'Bengaluru, IN', 'Remote'][i % 4],
    jobType: types[i % types.length],
    salary: i.isEven ? '₹${20 + i}k/mo' : 'Not disclosed',
    logoUrl: 'https://ui-avatars.com/api/?background=random&name=${[
      'Nimbus Labs',
      'Coral Tech',
      'Vertex Studio',
      'Harbor Systems',
      'Pixel Forge',
    ][i % 5].replaceAll(' ', '+')}',
    description:
        'We are looking for a motivated professional to join our growing team. '
        'You will work closely with designers and engineers to ship high-quality '
        'features, participate in code reviews, and help shape product direction.',
    skills: ['Flutter', 'Dart', 'REST APIs', 'Git'],
    experience: i.isEven ? '0-1 years' : '2-4 years',
    applyUrl: 'https://example.com/apply/$i',
  );
});