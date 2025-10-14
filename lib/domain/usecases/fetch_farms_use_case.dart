import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/data/source/farm_api_service.dart';

class FetchFarmsUsecase extends Nonparamsusescase<Either<dynamic, dynamic>> {
  final FarmApiService service;

  FetchFarmsUsecase(this.service);

  @override
  Future<Either<dynamic, dynamic>> call() async {
    return await service.fetchMyFarmDetails();
  }
}
