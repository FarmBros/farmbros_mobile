import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/domain/repository/farm_details_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class SaveFarmUseCase implements Usecases<Either, FarmDetailsParams> {
  @override
  Future<Either> call({FarmDetailsParams? param}) {
    return sl<FarmDetailsRepository>().saveFarmDetails(param!);
  }
}