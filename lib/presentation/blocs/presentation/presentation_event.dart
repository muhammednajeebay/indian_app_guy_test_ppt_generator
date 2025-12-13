import 'package:equatable/equatable.dart';
import '../../../data/models/presentation_request_model.dart';
import '../../../domain/entities/presentation.dart';

abstract class PresentationEvent extends Equatable {
  const PresentationEvent();

  @override
  List<Object> get props => [];
}

class GeneratePresentationRequested extends PresentationEvent {
  final PresentationRequestModel request;

  const GeneratePresentationRequested(this.request);

  @override
  List<Object> get props => [request];
}

// Placeholder for future download event if needed specifically in Bloc
class DownloadPresentationRequested extends PresentationEvent {
  final Presentation presentation;

  const DownloadPresentationRequested(this.presentation);

  @override
  List<Object> get props => [presentation];
}
