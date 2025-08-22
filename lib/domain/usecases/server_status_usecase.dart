import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/data/source/server_status_api_service.dart';

class ServerStatusUsecase extends Nonparamsusescase<Either<String, bool>> {
  final ServerStatusApiService service;

  ServerStatusUsecase(this.service);

  @override
  Future<Either<String, bool>> call() async {
    return await service.checkServerStatus();
  }
}
