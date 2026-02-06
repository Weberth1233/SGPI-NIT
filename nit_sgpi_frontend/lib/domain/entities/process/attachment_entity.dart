class AttachmentEntity {
  final int id;
  final String displayName;
  final String status;
  final String templateFilePath;
  final String signedFilePath;

  AttachmentEntity({
    required this.id,
    required this.displayName,
    required this.status,
    required this.templateFilePath,
    required this.signedFilePath,
  });
}
