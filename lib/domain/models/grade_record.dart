class GradeRecord {
  const GradeRecord({required this.id, required this.enrollmentId, required this.assessment,
    required this.score, required this.maxScore});
  final String id, enrollmentId, assessment;
  final double score, maxScore;
  double get percentage => maxScore <= 0 ? 0 : score / maxScore * 100;
  Map<String, Object?> toMap() => {'id': id, 'enrollment_id': enrollmentId,
    'assessment': assessment, 'score': score, 'max_score': maxScore};
  factory GradeRecord.fromMap(Map<String, Object?> m) => GradeRecord(
    id: m['id']! as String, enrollmentId: m['enrollment_id']! as String,
    assessment: m['assessment']! as String, score: (m['score']! as num).toDouble(),
    maxScore: (m['max_score']! as num).toDouble());
}
