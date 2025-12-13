import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/api_constants.dart';
import 'core/network/network_info.dart';
import 'core/network/api_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/presentation/presentation_bloc.dart';
import 'presentation/blocs/presentation_form/presentation_form_cubit.dart';
import 'data/datasources/presentation_remote_datasource.dart';
import 'data/repositories/presentation_repository_impl.dart';
import 'domain/repositories/presentation_repository.dart';
import 'domain/usecases/generate_presentation_usecase.dart';

final getit = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  getit.registerFactory(
    () => AuthBloc(
      loginUseCase: getit(),
      signupUseCase: getit(),
      authRepository: getit(),
    ),
  );
  getit.registerFactory(() => ThemeBloc());

  // Presentation Bloc
  getit.registerFactory(
    () => PresentationBloc(generatePresentationUseCase: getit()),
  );
  getit.registerFactory(() => PresentationFormCubit());

  // Use cases
  getit.registerLazySingleton(() => LoginUseCase(getit()));
  getit.registerLazySingleton(() => SignupUseCase(getit()));
  getit.registerLazySingleton(() => GeneratePresentationUseCase(getit()));

  // Repository
  getit.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getit(), networkInfo: getit()),
  );
  getit.registerLazySingleton<PresentationRepository>(
    () => PresentationRepositoryImpl(
      remoteDataSource: getit(),
      networkInfo: getit(),
    ),
  );

  // Data sources
  getit.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: getit()),
  );
  getit.registerLazySingleton<PresentationRemoteDataSource>(
    () => PresentationRemoteDataSourceImpl(apiClient: getit()),
  );

  //! Core
  getit.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getit()));
  getit.registerLazySingleton(() => ApiClient(dio: getit()));

  //! External
  final supabase = await Supabase.initialize(
    url: ApiConstants.supabaseUrl,
    anonKey: ApiConstants.supabaseAnonKey,
  );
  getit.registerLazySingleton(() => supabase.client);

  getit.registerLazySingleton(() => InternetConnectionChecker());
  getit.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  getit.registerLazySingleton(() => sharedPreferences);
}
