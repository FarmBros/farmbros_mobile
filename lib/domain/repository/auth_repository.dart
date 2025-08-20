import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';

abstract class AuthRepository {

  Future<Either> signIn(SignInReqParams signInReqParams);
}
