import '../../domain/entities/presentation.dart';

class PresentationResponseModel extends Presentation {
  PresentationResponseModel({required super.title, required super.url});

  factory PresentationResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final meta = data['json'] as Map<String, dynamic>? ?? {};

    return PresentationResponseModel(
      title: meta['presentationTitle'] ?? 'Generated Presentation',
      url: data['url'] ?? '',
    );
  }
}
