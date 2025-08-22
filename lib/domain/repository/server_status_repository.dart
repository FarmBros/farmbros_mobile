import 'package:dartz/dartz.dart';

abstract class ServerStatusRepository {
  Future<Either> checkServerStatus();
}
