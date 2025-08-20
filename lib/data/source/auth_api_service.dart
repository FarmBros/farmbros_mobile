import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:logger/logger.dart';

abstract class AuthApiService {
  Future<Either> signInRequest(SignInReqParams signInReqParams);
}

class AuthApiServiceImpl extends AuthApiService {
  Logger logger = Logger();

  @override
  Future<Either> signInRequest(SignInReqParams signInReqParams) async {
    try {
      logger.log(Level.info, signInReqParams.toMap());
      var signInResponse =
          sl<DioClient>().post(AppUtils.$login, data: signInReqParams.toMap());

      return Right(signInResponse);
    } on DioException catch (e) {
      return Left(e.response!.data["message"]);
    }
  }
}
