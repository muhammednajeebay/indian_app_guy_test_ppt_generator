import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/presentation_constants.dart';
import 'presentation_form_state.dart';

class PresentationFormCubit extends Cubit<PresentationFormState> {
  PresentationFormCubit()
    : super(
        PresentationFormState(
          template: PresentationConstants.defaultTemplates.first,
        ),
      );

  void toggleTemplateType(bool editable) {
    emit(
      state.copyWith(
        isEditable: editable,
        template: editable
            ? PresentationConstants.editableTemplates.first
            : PresentationConstants.defaultTemplates.first,
      ),
    );
  }

  void updateTemplate(String value) => emit(state.copyWith(template: value));

  void updateLanguage(String value) => emit(state.copyWith(language: value));

  void updateSlideCount(int value) => emit(state.copyWith(slideCount: value));

  void toggleAiImages(bool value) => emit(state.copyWith(aiImages: value));

  void toggleImageForEachSlide(bool value) =>
      emit(state.copyWith(imageForEachSlide: value));

  void toggleGoogleImage(bool value) =>
      emit(state.copyWith(googleImage: value));

  void toggleGoogleText(bool value) => emit(state.copyWith(googleText: value));

  void updateModel(String value) => emit(state.copyWith(model: value));

  void updateWatermarkPosition(String value) =>
      emit(state.copyWith(watermarkPosition: value));
}
