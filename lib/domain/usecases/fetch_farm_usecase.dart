import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_details_params.dart';
import 'package:farmbros_mobile/data/source/farm_api_service.dart';

class FetchFarmUsecase extends Usecases<Either, FetchFarmDetailsParams> {
  final FarmApiService service;

  FetchFarmUsecase(this.service);

  @override
  Future<Either> call({FetchFarmDetailsParams? param}) async {
    return await service.getFarmDetails(param!);
  }
}
