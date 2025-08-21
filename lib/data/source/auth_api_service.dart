import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';
import 'package:farmbros_mobile/data/models/sign_up_req_params.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:logger/logger.dart';

abstract class AuthApiService {
  Future<Either> signInRequest(SignInReqParams signInReqParams);
  Future<Either> signUpRequest(SignUpReqParams signUpReqParams);
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

  @override
  Future<Either> signUpRequest(SignUpReqParams signUpReqParams) async {
    try {
      logger.log(Level.info, signUpReqParams.toMap());
      var signUpResponse =
          sl<DioClient>().post(AppUtils.$register, data: signUpReqParams.toMap());

      return Right(signUpResponse);
    } on DioException catch (e) {
      return Left(e.response!.data["message"]);
    }
  }
}
