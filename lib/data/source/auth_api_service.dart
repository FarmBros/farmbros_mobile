import 'package:dartz/dartz.dart';

abstract class AuthApiService {

  Future<Either> signInRequest ();
}

class AuthApiServiceImpl extends AuthApiService {
  
  
  @override
  Future<Either> signInRequest() {
    // TODO: implement signInRequest
    throw UnimplementedError();
  }
}