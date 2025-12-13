import 'package:equatable/equatable.dart';
import '../../../domain/entities/presentation.dart';

abstract class PresentationState extends Equatable {
  const PresentationState();

  @override
  List<Object> get props => [];
}

class PresentationInitial extends PresentationState {}

class PresentationLoading extends PresentationState {}

class PresentationSuccess extends PresentationState {
  final Presentation presentation;

  const PresentationSuccess(this.presentation);

  @override
  List<Object> get props => [presentation];
}

class PresentationError extends PresentationState {
  final String message;

  const PresentationError(this.message);

  @override
  List<Object> get props => [message];
}
