import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../data/models/presentation_request_model.dart';
import '../entities/presentation.dart';
import '../repositories/presentation_repository.dart';

class GeneratePresentationUseCase {
  final PresentationRepository repository;

  GeneratePresentationUseCase(this.repository);

  Future<Either<Failure, Presentation>> call(
    PresentationRequestModel params,
  ) async {
    return await repository.generatePresentation(params);
  }
}
