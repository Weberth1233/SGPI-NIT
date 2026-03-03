class ProcessRequestEntity {
  final String title;
  final int ipTypeId;
  final bool isFeatured;
  final List<int> authorIds;
  final Map<String, dynamic> formData;

  const ProcessRequestEntity({
    required this.title,
    required this.ipTypeId,
    required this.isFeatured,
    required this.authorIds,
    required this.formData,
  });
}
