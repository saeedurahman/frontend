import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/return_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReturnDetailCubit extends Cubit<ReturnDetailState> {
  ReturnDetailCubit({
    required GetReturnByIdUseCase getReturnByIdUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getReturn = getReturnByIdUseCase,
        _authLocal = authLocalDataSource,
        super(const ReturnDetailState.initial());

  final GetReturnByIdUseCase _getReturn;
  final AuthLocalDataSource _authLocal;

  Future<void> load(String returnId) async {
    emit(const ReturnDetailState.loading());

    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewReturns(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const ReturnDetailState.accessDenied());
      return;
    }

    final result = await _getReturn(returnId);
    result.fold(
      (failure) => emit(ReturnDetailState.error(failure.message)),
      (item) => emit(ReturnDetailState.loaded(item: item)),
    );
  }
}
