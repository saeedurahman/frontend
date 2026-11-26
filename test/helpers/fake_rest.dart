import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frantend/core/data_changes/data_change_interceptor.dart';

import 'fake_http.dart';
import 'offline_world.dart';

/// One request as the fake server sees it.
class FakeCall {
  FakeCall(this.options, this.params, this.body);

  final RequestOptions options;

  /// The `{name}` parts of the route.
  final Map<String, String> params;

  /// The JSON body (empty for a GET).
  final Map<String, dynamic> body;

  Map<String, dynamic> get query => options.queryParameters;
}

/// Answers a request with a JSON value, or with a ready [ResponseBody].
typedef FakeRoute = FutureOr<Object?> Function(FakeCall call);

/// Rows of one collection. New rows go to the END, so a screen that shows a
/// new row first did that itself.
class FakeCollection {
  FakeCollection(this.rows);

  final List<Map<String, dynamic>> rows;

  List<String> get ids => [for (final r in rows) r['id'] as String];

  Map<String, dynamic> byId(String id) =>
      rows.firstWhere((r) => r['id'] == id);
}

/// A small in-memory REST backend behind a real [Dio], so tests run the real
/// data sources, repositories and use cases. Its client carries the same
/// [DataChangeInterceptor] as the app's.
class FakeRest implements HttpClientAdapter {
  FakeRest() {
    dio = Dio(BaseOptions(baseUrl: 'http://fake.test'))
      ..httpClientAdapter = this
      ..interceptors.add(DataChangeInterceptor());
    client = FakeDioClient(dio);
  }

  late final Dio dio;
  late final FakeDioClient client;

  /// Every request, as "METHOD /path".
  final List<String> log = [];

  final List<_Route> _routes = [];
  int _created = 0;

  String newId([String prefix = 'srv']) => '$prefix-${++_created}';

  /// [pattern] is a path such as `/expenses/{id}/payments`. A route with fewer
  /// `{}` parts wins; between equals, the one registered last.
  void on(String method, String pattern, FakeRoute route) =>
      _routes.add(_Route(method, _split(pattern), route));

  /// `GET path`, `GET path/{id}`, `POST path`, `PATCH`/`PUT path/{id}`.
  ///
  /// [created] are the fields the server adds to a posted body. [paged] makes
  /// the list answer `{items, total, skip, limit}`.
  FakeCollection collection(
    String path, {
    List<Map<String, dynamic>> seed = const [],
    Map<String, dynamic> Function(Map<String, dynamic> body)? created,
    bool paged = false,
    String prefix = 'srv',
  }) {
    final rows = FakeCollection([for (final r in seed) {...r}]);
    on('GET', path, (call) {
      final skip = int.tryParse('${call.query['skip'] ?? 0}') ?? 0;
      final limit = int.tryParse('${call.query['limit'] ?? 200}') ?? 200;
      final page = rows.rows.skip(skip).take(limit).toList();
      if (!paged) return page;
      return {
        'items': page,
        'total': rows.rows.length,
        'skip': skip,
        'limit': limit,
      };
    });
    on('POST', path, (call) {
      final row = <String, dynamic>{
        ...call.body,
        ...?created?.call(call.body),
        'id': newId(prefix),
      };
      rows.rows.add(row);
      return row;
    });
    on('GET', '$path/{id}', (call) {
      final id = call.params['id'];
      for (final r in rows.rows) {
        if (r['id'] == id) return r;
      }
      return jsonResponse({'detail': 'Not found'}, status: 404);
    });
    for (final method in const ['PATCH', 'PUT']) {
      on(method, '$path/{id}', (call) {
        final row = rows.byId(call.params['id']!);
        row.addAll(call.body);
        return row;
      });
    }
    return rows;
  }

  static List<String> _split(String path) =>
      path.split('/').where((s) => s.isNotEmpty).toList();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final method = options.method.toUpperCase();
    final path = Uri.parse(options.path).path;
    log.add('$method $path');
    final segments = _split(path);
    _Route? best;
    for (final route in _routes) {
      if (!route.matches(method, segments)) continue;
      if (best == null || route.wildcards <= best.wildcards) best = route;
    }
    if (best == null) {
      return jsonResponse({'detail': 'No route: $method $path'}, status: 404);
    }
    final data = options.data;
    final body = data is Map
        ? jsonDecode(jsonEncode(data)) as Map<String, dynamic>
        : <String, dynamic>{};
    final answer = await best.route(
      FakeCall(options, best.params(segments), body),
    );
    if (answer is ResponseBody) return answer;
    return jsonResponse(answer, status: method == 'POST' ? 201 : 200);
  }

  @override
  void close({bool force = false}) {}
}

class _Route {
  _Route(this.method, this.segments, this.route);

  final String method;
  final List<String> segments;
  final FakeRoute route;

  int get wildcards => segments.where(_isWildcard).length;

  static bool _isWildcard(String s) => s.startsWith('{');

  bool matches(String method, List<String> path) {
    if (method != this.method || path.length != segments.length) return false;
    for (var i = 0; i < path.length; i++) {
      if (!_isWildcard(segments[i]) && segments[i] != path[i]) return false;
    }
    return true;
  }

  Map<String, String> params(List<String> path) => {
        for (var i = 0; i < segments.length; i++)
          if (_isWildcard(segments[i]))
            segments[i].substring(1, segments[i].length - 1): path[i],
      };
}
