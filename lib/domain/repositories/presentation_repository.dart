import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../data/models/presentation_request_model.dart';
import '../entities/presentation.dart';

abstract class PresentationRepository {
  Future<Either<Failure, Presentation>> generatePresentation(
    PresentationRequestModel request,
  );
}
