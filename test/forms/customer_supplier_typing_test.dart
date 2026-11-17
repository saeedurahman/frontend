// Customer and supplier forms, typed into one key at a time with the REAL
// cubits, use cases and repositories (fake HTTP). A field must keep its caret
// while the cubit emits and the page rebuilds ("1500" must not become "0051").
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_cubit.dart';
import 'package:frantend/features/customers/presentation/pages/customer_form_page.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:frantend/features/suppliers/presentation/pages/supplier_form_page.dart';

import '../helpers/fake_http.dart';
import '../helpers/form_typing.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

void _swap<T extends Object>(T Function() make) {
  if (sl.isRegistered<T>()) sl.unregister<T>();
  sl.registerFactory<T>(make);
}

Future<void> _open(WidgetTester t, Widget page) async {
  ignoreOverflowErrors();
  t.view.physicalSize = const Size(1400, 1800);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(MaterialApp(home: Scaffold(body: page)));
  await t.pumpAndSettle();
}

/// Empties a field the way select-all + delete does.
Future<void> _clear(WidgetTester t, Finder f) async {
  await focusField(t, f);
  editableState(t, f).userUpdateTextEditingValue(
    const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
    SelectionChangedCause.keyboard,
  );
  await settle(t);
}

void main() {
  late Dio dio;
  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = FakeAdapter((o) => jsonResponse(<dynamic>[]));
  });

  group('customer form', () {
    late CustomerFormCubit cubit;
    setUp(() {
      final repo = CustomersRepositoryImpl(
        remoteDataSource: CustomersRemoteDataSourceImpl(_Dio(dio)),
        errorHandler: const ErrorHandler(),
      );
      cubit = CustomerFormCubit(
        getCustomerUseCase: GetCustomerUseCase(repo),
        createCustomerUseCase: CreateCustomerUseCase(repo),
        updateCustomerUseCase: UpdateCustomerUseCase(repo),
        productsRepository: null,
      );
      _swap<CustomerFormCubit>(() => cubit);
    });

    testWidgets('name, phone and credit limit keep what is typed', (t) async {
      await _open(t, const CustomerFormPage());
      final name = find.widgetWithText(TextField, 'Name *');
      final phone = find.widgetWithText(TextField, 'Phone');
      final credit = find.widgetWithText(TextField, 'Credit Limit');

      await typeCharByChar(t, name, 'Ali Khan', afterEach: (_, s) => expect(cubit.state.name, s));
      await typeCharByChar(t, phone, '03001234567',
          afterEach: (_, s) => expect(cubit.state.phone, s));
      await _clear(t, credit);
      await typeCharByChar(t, credit, '1500.50',
          afterEach: (_, s) => expect(cubit.state.creditLimit, s), focus: false);
      expect(shownIn(t, credit), '1500.50');
      expect(shownIn(t, name), 'Ali Khan');
    });
  });

  group('supplier form', () {
    late SupplierFormCubit cubit;
    setUp(() {
      final repo = SuppliersRepositoryImpl(
        remoteDataSource: SuppliersRemoteDataSourceImpl(_Dio(dio)),
        errorHandler: const ErrorHandler(),
      );
      cubit = SupplierFormCubit(
        getSupplierUseCase: GetSupplierUseCase(repo),
        createSupplierUseCase: CreateSupplierUseCase(repo),
        updateSupplierUseCase: UpdateSupplierUseCase(repo),
      );
      _swap<SupplierFormCubit>(() => cubit);
    });

    testWidgets('name, phone and payment terms keep what is typed', (t) async {
      await _open(t, const SupplierFormPage());
      final name = find.widgetWithText(TextField, 'Name *');
      final phone = find.widgetWithText(TextField, 'Phone');
      final terms = find.widgetWithText(TextField, 'Payment Terms (days)');

      await typeCharByChar(t, name, 'Al Shifa', afterEach: (_, s) => expect(cubit.state.name, s));
      await typeCharByChar(t, phone, '0421234567',
          afterEach: (_, s) => expect(cubit.state.phone, s));
      await _clear(t, terms);
      await typeCharByChar(t, terms, '45',
          afterEach: (_, s) => expect(cubit.state.paymentTermsDays, s), focus: false);
      expect(shownIn(t, terms), '45');
    });
  });
}
