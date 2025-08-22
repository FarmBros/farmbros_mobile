import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class ServerStatusApiService {
  Future<Either<String, bool>> checkServerStatus();
}

class ServerStatusApiServiceImpl extends ServerStatusApiService {
  @override
  Future<Either<String, bool>> checkServerStatus() async {
    try {
      final response = await sl<DioClient>().get(AppUtils.$baseUrl);

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left("Server responded with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return Left(
          e.response?.data["message"] ?? "Server unreachable, Try again later");
    } catch (e) {
      return Left("Unexpected error: $e");
    }
  }
}
