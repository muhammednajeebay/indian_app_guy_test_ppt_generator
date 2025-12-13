import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/presentation.dart';
import '../../domain/repositories/presentation_repository.dart';
import '../datasources/presentation_remote_datasource.dart';
import '../models/presentation_request_model.dart';

class PresentationRepositoryImpl implements PresentationRepository {
  final PresentationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PresentationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Presentation>> generatePresentation(
    PresentationRequestModel request,
  ) async {
    bluePrint('➡️ PresentationRepository: Generating presentation request');

    if (await networkInfo.isConnected) {
      try {
        final presentation = await remoteDataSource.generatePresentation(
          request,
        );
        greenPrint('✅ PresentationRepository: Request successful');
        return Right(presentation);
      } on ServerException catch (e) {
        redPrint('❌ PresentationRepository: Request failed: ${e.message}');
        return Left(ServerFailure(message: e.message));
      }
    } else {
      redPrint('❌ PresentationRepository: No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
