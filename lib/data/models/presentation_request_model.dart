class PresentationRequestModel {
  final String topic;
  final String email;
  final String accessId;
  final String? template;
  final String? language;

  // TODO: Add other fields as per requirements

  PresentationRequestModel({
    required this.topic,
    required this.email,
    required this.accessId,
    this.template,
    this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'email': email,
      'accessId': accessId,
      'template': template,
      'language': language,
    };
  }
}
