import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
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
    if (signInReqParams.username == "" || signInReqParams.password == "") {
      return Left("All fields are required");
    }
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$login, data: signInReqParams.toMap());

      final responseData = response.data;
      if (responseData["status"] == "success") {
        final token = responseData["data"];
        logger.log(Level.info, token);

        await sl<SessionCubit>().createSession(token);

        return Right(responseData);
      } else {
        return Left(responseData["message"] ?? "Login failed");
      }
    } on DioException catch (e) {
      String errorMessage = "Login failed";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> signUpRequest(SignUpReqParams signUpReqParams) async {
    if (signUpReqParams.email == "" ||
        signUpReqParams.firstName == "" ||
        signUpReqParams.lastName == "" ||
        signUpReqParams.password == "" ||
        signUpReqParams.phoneNumber == "" ||
        signUpReqParams.username == "" ||
        signUpReqParams.fullName == "") {
      return Left("All fields are required");
    }

    try {
      logger.log(Level.info, signUpReqParams.toMap());
      var signUpResponse = await sl<DioClient>()
          .post(AppUtils.$register, data: signUpReqParams.toMap());

      final responseData = signUpResponse.data;

      if (responseData["status"] == "success") {
        return Right(signUpResponse);
      } else {
        return Left(responseData["message"] ?? "Registration failed");
      }
    } on DioException catch (e) {
      String errorMessage = "Registration failed";
      if (e.response?.data != null) {
        if (e.response!.data is Map && e.response!.data["message"] != null) {
          errorMessage = e.response!.data["message"];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }
}
