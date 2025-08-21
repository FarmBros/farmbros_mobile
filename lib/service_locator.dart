import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/repository/auth_repository_impl.dart';
import 'package:farmbros_mobile/data/source/auth_api_service.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/domain/usecases/sign_in_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/sign_up_use_case.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
}
