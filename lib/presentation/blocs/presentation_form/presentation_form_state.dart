import 'package:equatable/equatable.dart';

class PresentationFormState extends Equatable {
  final bool isEditable;
  final String template;
  final String language;
  final int slideCount;
  final bool aiImages;
  final bool imageForEachSlide;
  final bool googleImage;
  final bool googleText;
  final String model;
  final String watermarkPosition;

  const PresentationFormState({
    this.isEditable = false,
    required this.template,
    this.language = 'en',
    this.slideCount = 10,
    this.aiImages = false,
    this.imageForEachSlide = true,
    this.googleImage = false,
    this.googleText = false,
    this.model = 'gpt-3.5',
    this.watermarkPosition = 'BottomRight',
  });

  PresentationFormState copyWith({
    bool? isEditable,
    String? template,
    String? language,
    int? slideCount,
    bool? aiImages,
    bool? imageForEachSlide,
    bool? googleImage,
    bool? googleText,
    String? model,
    String? watermarkPosition,
  }) {
    return PresentationFormState(
      isEditable: isEditable ?? this.isEditable,
      template: template ?? this.template,
      language: language ?? this.language,
      slideCount: slideCount ?? this.slideCount,
      aiImages: aiImages ?? this.aiImages,
      imageForEachSlide: imageForEachSlide ?? this.imageForEachSlide,
      googleImage: googleImage ?? this.googleImage,
      googleText: googleText ?? this.googleText,
      model: model ?? this.model,
      watermarkPosition: watermarkPosition ?? this.watermarkPosition,
    );
  }

  @override
  List<Object> get props => [
    isEditable,
    template,
    language,
    slideCount,
    aiImages,
    imageForEachSlide,
    googleImage,
    googleText,
    model,
    watermarkPosition,
  ];
}
