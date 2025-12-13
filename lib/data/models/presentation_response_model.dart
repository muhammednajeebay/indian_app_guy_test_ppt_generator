import '../../domain/entities/presentation.dart';

class PresentationResponseModel extends Presentation {
  PresentationResponseModel({required super.title, required super.url});

  factory PresentationResponseModel.fromJson(Map<String, dynamic> json) {
    return PresentationResponseModel(
      title: json['title'] ?? 'Generated Presentation',
      url: json['url'] ?? '',
    );
  }
}
