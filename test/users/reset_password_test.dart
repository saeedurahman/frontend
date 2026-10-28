import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/users/data/datasources/users_remote_datasource.dart';
import 'package:frantend/features/users/presentation/widgets/reset_password_dialog.dart';

import '../helpers/fake_http.dart';

class _StubDioClient implements DioClient {
  _StubDioClient(this._dio);
  final Dio _dio;

  @override
  Dio get dio => _dio;
}

void main() {
  test('reset password PUTs {new_password} to /users/{id}/password', () async {
    final adapter = FakeAdapter((o) => jsonResponse({}));
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = adapter;
    final remote = UsersRemoteDataSourceImpl(_StubDioClient(dio));

    await remote.resetUserPassword(id: 'u1', newPassword: 'Secret123');

    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/users/u1/password');
    expect(request.data, {'new_password': 'Secret123'});
  });

  group('validateNewStaffPassword', () {
    test('rejects empty, short and mismatched passwords', () {
      expect(validateNewStaffPassword('', ''), isNotNull);
      expect(validateNewStaffPassword('short', 'short'), isNotNull);
      expect(validateNewStaffPassword('LongEnough1', 'Different1'),
          'Passwords do not match');
    });

    test('accepts a long enough matching password', () {
      expect(validateNewStaffPassword('LongEnough1', 'LongEnough1'), isNull);
    });
  });
}
