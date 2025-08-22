import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/domain/repository/server_status_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class ServerStatusUsecase implements Nonparamsusescase<Either> {
  @override
  Future<Either> call() {
    return sl<ServerStatusRepository>().checkServerStatus();
  }
}
