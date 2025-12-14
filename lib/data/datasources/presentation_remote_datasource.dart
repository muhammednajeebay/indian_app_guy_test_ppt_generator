import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/logger.dart';
import '../models/presentation_request_model.dart';
import '../models/presentation_response_model.dart';

abstract class PresentationRemoteDataSource {
  Future<PresentationResponseModel> generatePresentation(
    PresentationRequestModel request,
  );
}

class PresentationRemoteDataSourceImpl implements PresentationRemoteDataSource {
  final ApiClient apiClient;

  PresentationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PresentationResponseModel> generatePresentation(
    PresentationRequestModel request,
  ) async {
    bluePrint(
      '➡️ PresentationRemoteDataSource: Generating presentation for topic: ${request.topic}',
    );
    try {
      final response = await apiClient.post(
        ApiConstants.pptFromTopicEndpoint,
        data: request.toJson(),
      );

      greenPrint(
        '✅ PresentationRemoteDataSource: Generation successful: ${response.data}',
      );

      // Handle case where API might return just the URL as a string or different structure
      // Adjust parsing logic as per actual API response
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data['data'];

        // Check for business error hidden in 200 OK
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('message') &&
              !responseData.containsKey('url')) {
            throw ServerException(
              message: responseData['message'] ?? 'Generation failed',
            );
          }
        }

        final model = PresentationResponseModel.fromJson(response.data);
        if (model.url.isEmpty) {
          throw ServerException(message: 'Received empty URL from server');
        }

        return model;
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } on DioException catch (e) {
      redPrint(
        '❌ PresentationRemoteDataSource: Generation failed: ${e.message}',
      );
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown error',
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      redPrint('❌ PresentationRemoteDataSource: Unexpected error: $e');
      throw ServerException(message: e.toString());
    }
  }
}
