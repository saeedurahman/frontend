import 'package:dio/dio.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';

/// In-memory stand-in for the backend `/receipt-layouts` endpoints.
class FakeLayoutApi extends ReceiptLayoutApi {
  FakeLayoutApi() : super(Dio());

  final Map<String, Map<String, dynamic>> layouts = {};
  final Map<String, Map<String, dynamic>> assigned = {};
  final List<String> calls = [];
  int _n = 0;

  /// Next call fails as the network being down.
  bool offline = false;

  void _gate() {
    if (offline) {
      throw const ReceiptApiException('You are offline.', offline: true);
    }
  }

  String _id() => 'lay-${++_n}';

  Map<String, dynamic> seed(
    String name,
    ReceiptDesign design, {
    bool pharmacy = false,
  }) {
    final id = _id();
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'design': design.code,
      'paper': design.defaultPaper.code,
      'config': ReceiptLayoutConfig.defaultsFor(design, pharmacy: pharmacy).toJson(),
      'is_active': true,
    };
    layouts[id] = json;
    return json;
  }

  void assign(ReceiptChannel channel, String layoutId, {String? branchId}) {
    final id = 'as-${channel.code}-${branchId ?? 'biz'}';
    assigned[id] = {
      'id': id,
      'channel': channel.code,
      'branch_id': branchId,
      'layout_id': layoutId,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    _gate();
    calls.add('list');
    return layouts.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> designs() async {
    _gate();
    return [
      for (final d in ReceiptDesign.values)
        {'code': d.code, 'title': d.title, 'papers': [d.defaultPaper.code]},
    ];
  }

  @override
  Future<Map<String, dynamic>> create({
    required String name,
    required String design,
    String? paper,
    Map<String, Object?>? config,
  }) async {
    _gate();
    calls.add('create');
    final id = _id();
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'design': design,
      'paper': paper ?? ReceiptDesign.fromCode(design).defaultPaper.code,
      'config': config ?? ReceiptLayoutConfig.defaultsFor(ReceiptDesign.fromCode(design)).toJson(),
      'is_active': true,
    };
    layouts[id] = json;
    return Map<String, dynamic>.from(json);
  }

  @override
  Future<Map<String, dynamic>> update(
    String id, {
    String? name,
    String? paper,
    Map<String, Object?>? config,
    bool? isActive,
  }) async {
    _gate();
    calls.add('update');
    final row = layouts[id];
    if (row == null) throw const ReceiptApiException('Not found', status: 404);
    if (name != null) row['name'] = name;
    if (paper != null) row['paper'] = paper;
    if (config != null) row['config'] = config;
    if (isActive != null) row['is_active'] = isActive;
    return Map<String, dynamic>.from(row);
  }

  @override
  Future<void> delete(String id) async {
    _gate();
    calls.add('delete');
    final inUse = assigned.values.any((a) => a['layout_id'] == id);
    if (inUse) {
      throw const ReceiptApiException(
        'This layout is used as a default. Pick another layout there first.',
        status: 409,
        code: 'layout_assigned',
      );
    }
    layouts.remove(id);
  }

  @override
  Future<Map<String, dynamic>> duplicate(String id, {String? name}) async {
    _gate();
    calls.add('duplicate');
    final src = layouts[id];
    if (src == null) throw const ReceiptApiException('Not found', status: 404);
    final copyId = _id();
    final copy = <String, dynamic>{
      ...Map<String, dynamic>.from(src),
      'id': copyId,
      'name': name ?? '${src['name']} copy',
    };
    layouts[copyId] = copy;
    return Map<String, dynamic>.from(copy);
  }

  @override
  Future<List<Map<String, dynamic>>> assignments() async {
    _gate();
    return assigned.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> putAssignments(
    List<Map<String, Object?>> assignments,
  ) async {
    _gate();
    calls.add('putAssignments');
    final out = <Map<String, dynamic>>[];
    for (final a in assignments) {
      final id = 'as-${a['channel']}-${a['branch_id'] ?? 'biz'}';
      if (a['layout_id'] == null) {
        assigned.remove(id);
        continue;
      }
      final row = <String, dynamic>{
        'id': id,
        'channel': a['channel'],
        'branch_id': a['branch_id'],
        'layout_id': a['layout_id'],
      };
      assigned[id] = row;
      out.add(row);
    }
    return out;
  }
}
