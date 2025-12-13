class PresentationRequestModel {
  final String topic;
  final String email;
  final String accessId;
  final String? template;
  final String? language;
  final int slideCount;
  final bool aiImages;
  final bool imageForEachSlide;
  final bool googleImage;
  final bool googleText;
  final String? model;
  final String? presentationFor;
  final Map<String, String>? watermark;

  PresentationRequestModel({
    required this.topic,
    required this.email,
    required this.accessId,
    this.template,
    this.language,
    this.slideCount = 10,
    this.aiImages = false,
    this.imageForEachSlide = true,
    this.googleImage = false,
    this.googleText = false,
    this.model,
    this.presentationFor,
    this.watermark,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'email': email,
      'accessId': accessId,
      if (template != null) 'template': template,
      if (language != null) 'language': language,
      'slideCount': slideCount,
      'aiImages': aiImages,
      'imageForEachSlide': imageForEachSlide,
      'googleImage': googleImage,
      'googleText': googleText,
      if (model != null) 'model': model,
      if (presentationFor != null) 'presentationFor': presentationFor,
      if (watermark != null) 'watermark': watermark,
    };
  }
}
