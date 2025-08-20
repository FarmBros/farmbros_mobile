import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class SignInUseCase  implements Usecases<Either, SignInReqParams>{
  @override
  Future<Either> call({SignInReqParams? param}) {
   return  sl<AuthRepository>().signIn(param!);
  }

}