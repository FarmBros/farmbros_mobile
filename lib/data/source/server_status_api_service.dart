import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class ServerStatusApiService {
  Future<Either> checkServerStatus();
}

class ServerStatusApiServiceImpl extends ServerStatusApiService {
  @override
  Future<Either> checkServerStatus() async {
    try {
      var checkServerStatusResponse = sl<DioClient>().post(AppUtils.$baseUrl);

      return Right(checkServerStatusResponse);
    } on DioException catch (e) {
      return Left(e.response!.data["message"]);
    }
  }
}
