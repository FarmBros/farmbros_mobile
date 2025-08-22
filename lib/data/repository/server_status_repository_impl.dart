import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/source/server_status_api_service.dart';
import 'package:farmbros_mobile/domain/repository/server_status_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class ServerStatusRepositoryImpl extends ServerStatusRepository {
  @override
  Future<Either> checkServerStatus() {
    return sl<ServerStatusApiService>().checkServerStatus();
  }
}
