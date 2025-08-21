import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/sign_up_req_params.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class SignUpUseCase implements Usecases<Either, SignUpReqParams> {
  @override
  Future<Either> call({SignUpReqParams? param}) {
    return sl<AuthRepository>().signUp(param!);
  }
}
