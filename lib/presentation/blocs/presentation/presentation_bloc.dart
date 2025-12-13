import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/generate_presentation_usecase.dart';
import 'presentation_event.dart';
import 'presentation_state.dart';

class PresentationBloc extends Bloc<PresentationEvent, PresentationState> {
  final GeneratePresentationUseCase generatePresentationUseCase;

  PresentationBloc({required this.generatePresentationUseCase})
    : super(PresentationInitial()) {
    on<GeneratePresentationRequested>(_onGeneratePresentationRequested);
  }

  Future<void> _onGeneratePresentationRequested(
    GeneratePresentationRequested event,
    Emitter<PresentationState> emit,
  ) async {
    emit(PresentationLoading());
    final result = await generatePresentationUseCase(event.request);
    result.fold(
      (failure) => emit(PresentationError(failure.message)),
      (presentation) => emit(PresentationSuccess(presentation)),
    );
  }
}
