import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';
import 'package:farmbros_mobile/data/models/sign_up_req_params.dart';
import 'package:farmbros_mobile/data/source/auth_api_service.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signIn(SignInReqParams signInReqParams) async {
    return sl<AuthApiService>().signInRequest(signInReqParams);
  }

  @override
  Future<Either> signUp(SignUpReqParams signUpReqParams) async {
    return sl<AuthApiService>().signUpRequest(signUpReqParams);
  }
}
