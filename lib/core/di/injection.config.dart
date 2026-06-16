// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/pin_login_usecase.dart' as _i564;
import '../../features/auth/domain/usecases/register_business_usecase.dart'
    as _i642;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/register/data/repositories/register_repository_impl.dart'
    as _i68;
import '../../features/register/domain/repositories/register_repository.dart'
    as _i994;
import '../../features/register/presentation/cubit/register_cubit.dart'
    as _i266;
import '../database/app_database.dart' as _i982;
import '../database/daos/products_dao.dart' as _i839;
import '../database/daos/sales_dao.dart' as _i340;
import '../database/daos/sync_queue_dao.dart' as _i428;
import '../error/error_handler.dart' as _i308;
import '../localization/locale_cubit.dart' as _i960;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../router/route_guards.dart' as _i525;
import '../storage/preferences_storage.dart' as _i574;
import '../storage/secure_storage.dart' as _i619;
import '../sync/conflict_resolver.dart' as _i50;
import '../sync/sync_manager.dart' as _i417;
import '../sync/sync_queue.dart' as _i554;
import '../sync/sync_worker.dart' as _i987;
import 'database_module.dart' as _i384;
import 'dio_module.dart' as _i1045;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final preferencesModule = _$PreferencesModule();
    final connectivityModule = _$ConnectivityModule();
    final databaseModule = _$DatabaseModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => preferencesModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i982.AppDatabase>(() => _i982.AppDatabase());
    gh.lazySingleton<_i308.ErrorHandler>(() => const _i308.ErrorHandler());
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i619.SecureStorage>(() => _i619.SecureStorage());
    gh.lazySingleton<_i50.ConflictResolver>(() => _i50.ConflictResolver());
    gh.lazySingleton<_i574.PreferencesStorage>(
      () => _i574.PreferencesStorage(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i428.SyncQueueDao>(
      () => databaseModule.syncQueueDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i839.ProductsDao>(
      () => databaseModule.productsDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i340.SalesDao>(
      () => databaseModule.salesDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(
        gh<_i619.SecureStorage>(),
        gh<_i982.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i525.AuthGuard>(
      () => _i525.AuthGuard(gh<_i619.SecureStorage>()),
    );
    gh.lazySingleton<_i554.SyncQueue>(
      () => _i554.SyncQueue(gh<_i428.SyncQueueDao>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        secureStorage: gh<_i619.SecureStorage>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        syncQueue: gh<_i554.SyncQueue>(),
      ),
    );
    gh.factory<_i960.LocaleCubit>(
      () => _i960.LocaleCubit(gh<_i574.PreferencesStorage>()),
    );
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio(gh<_i667.DioClient>()));
    gh.lazySingleton<_i417.SyncManager>(
      () => _i417.SyncManager(
        dioClient: gh<_i667.DioClient>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        syncQueue: gh<_i554.SyncQueue>(),
        syncQueueDao: gh<_i428.SyncQueueDao>(),
        conflictResolver: gh<_i50.ConflictResolver>(),
        preferencesStorage: gh<_i574.PreferencesStorage>(),
      ),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i987.SyncWorker>(
      () => _i987.SyncWorker(gh<_i417.SyncManager>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
        localDataSource: gh<_i992.AuthLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        errorHandler: gh<_i308.ErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i994.RegisterRepository>(
      () => _i68.RegisterRepositoryImpl(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i564.PinLoginUseCase>(
      () => _i564.PinLoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i642.RegisterBusinessUseCase>(
      () => _i642.RegisterBusinessUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        loginUseCase: gh<_i188.LoginUseCase>(),
        pinLoginUseCase: gh<_i564.PinLoginUseCase>(),
        registerBusinessUseCase: gh<_i642.RegisterBusinessUseCase>(),
        logoutUseCase: gh<_i48.LogoutUseCase>(),
        authRepository: gh<_i787.AuthRepository>(),
        authGuard: gh<_i525.AuthGuard>(),
      ),
    );
    gh.factory<_i266.RegisterCubit>(
      () => _i266.RegisterCubit(gh<_i994.RegisterRepository>()),
    );
    return this;
  }
}

class _$PreferencesModule extends _i574.PreferencesModule {}

class _$ConnectivityModule extends _i932.ConnectivityModule {}

class _$DatabaseModule extends _i384.DatabaseModule {}

class _$DioModule extends _i1045.DioModule {}
