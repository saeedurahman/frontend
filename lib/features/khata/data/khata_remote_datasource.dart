import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

/// How the hub list is ordered.
enum HubSort { amount, age, name }

/// What one hub request asks for.
class HubQuery {
  const HubQuery({
    required this.party,
    this.search = '',
    this.bucket,
    this.sort = HubSort.amount,
    this.branchId,
  });

  final PartyType party;
  final String search;
  final AgeBucket? bucket;
  final HubSort sort;
  final String? branchId;

  bool get isUnfiltered => search.trim().isEmpty && bucket == null;
}

/// `yyyy-MM-dd`, the wire form of a calendar day.
String khataIsoDay(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// The khata endpoints that are not part of a customer or supplier screen of
/// their own. Methods throw `DioException`; the repository maps them.
class KhataRemoteDataSource {
  KhataRemoteDataSource(this._dio);

  final Dio _dio;

  static const summaryPath = '/khata/summary';
  static const followupsPath = '/khata/followups';
  static const linkPath = '/statements/link';

  static String _party(PartyType type, String id) =>
      '/${type.collection}/$id';

  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, dynamic>? query,
  ]) async {
    final response =
        await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
    return response.data ?? const {};
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: idempotencyKey == null
          ? null
          : Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    return response.data ?? const {};
  }

  Future<HubPage> hub(HubQuery q, {int skip = 0, int limit = 50}) async {
    final json = await _get(
      q.party.isCustomer ? '/khata/receivables' : '/khata/payables',
      {
        if (q.search.trim().isNotEmpty) 'search': q.search.trim(),
        if (q.bucket != null) 'bucket': q.bucket!.apiValue,
        'sort': q.sort.name,
        'skip': skip,
        'limit': limit,
        if (q.branchId != null) 'branch_id': q.branchId,
      },
    );
    return HubPage.fromJson(json);
  }

  Future<KhataOverview> overview({String? branchId}) async =>
      KhataOverview.fromJson(
        await _get(summaryPath, {if (branchId != null) 'branch_id': branchId}),
      );

  /// The raw body, so it can be kept for offline use.
  Future<Map<String, dynamic>> openItems(
    PartyType type,
    String id, {
    String? branchId,
  }) =>
      _get(
        '${_party(type, id)}/open-items',
        {if (branchId != null) 'branch_id': branchId},
      );

  Future<List<Map<String, dynamic>>> followups(
    PartyType type,
    String id, {
    String? branchId,
    int limit = 100,
  }) async {
    final json = await _get(followupsPath, {
      'party_type': type.apiValue,
      'party_id': id,
      'limit': limit,
      if (branchId != null) 'branch_id': branchId,
    });
    final items = json['items'];
    return [
      if (items is List)
        for (final e in items.whereType<Map<dynamic, dynamic>>())
          Map<String, dynamic>.from(e),
    ];
  }

  Map<String, dynamic> _statementQuery({
    DateTime? from,
    DateTime? to,
    String? detail,
    String? branchId,
  }) =>
      {
        if (from != null) 'date_from': khataIsoDay(from),
        if (to != null) 'date_to': khataIsoDay(to),
        if (detail != null) 'detail': detail,
        if (branchId != null) 'branch_id': branchId,
      };

  Future<Map<String, dynamic>> statement(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String? detail,
    String? branchId,
  }) =>
      _get('${_party(type, id)}/statement', {
        ..._statementQuery(
          from: from,
          to: to,
          detail: detail,
          branchId: branchId,
        ),
        'include_logo_base64': true,
      });

  Future<Uint8List> statementPdf(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String? detail,
    String? branchId,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        '${_party(type, id)}/statement',
        queryParameters: {
          ..._statementQuery(
            from: from,
            to: to,
            detail: detail,
            branchId: branchId,
          ),
          'format': 'pdf',
        },
        options: Options(
          responseType: ResponseType.bytes,
          // A long account takes a while to draw.
          receiveTimeout: const Duration(seconds: 90),
        ),
      );
      return Uint8List.fromList(response.data ?? const []);
    } on DioException catch (e) {
      // The error body arrives as bytes too: give the code back its shape.
      final data = e.response?.data;
      if (data is List<int>) {
        try {
          e.response!.data = jsonDecode(utf8.decode(data));
        } catch (_) {/* not JSON: leave it */}
      }
      rethrow;
    }
  }

  Future<StatementLink> createLink(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String? detail,
    String? branchId,
    String? idempotencyKey,
  }) async =>
      StatementLink.fromJson(await _post(
        linkPath,
        {
          'party_type': type.apiValue,
          'party_id': id,
          ..._statementQuery(
            from: from,
            to: to,
            detail: detail,
            branchId: branchId,
          ),
        },
        idempotencyKey: idempotencyKey,
      ));

  Future<LedgerEntryResult> openingBalance(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async =>
      LedgerEntryResult.fromJson(await _post(
        '${_party(type, id)}/opening-balance',
        body,
        idempotencyKey: idempotencyKey,
      ));

  Future<LedgerEntryResult> manualEntry(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async =>
      LedgerEntryResult.fromJson(await _post(
        '${_party(type, id)}/manual-entry',
        body,
        idempotencyKey: idempotencyKey,
      ));

  Future<void> reverseEntry(
    PartyType type,
    String entryId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    await _post(
      '/${type.collection}/entries/$entryId/reverse',
      body,
      idempotencyKey: idempotencyKey,
    );
  }

  /// A customer or supplier created together with an opening balance: only
  /// the server can do both at once.
  Future<Map<String, dynamic>> createParty(
    PartyType type,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _post(
        type.isCustomer ? ApiConstants.customers : ApiConstants.suppliers,
        body,
        idempotencyKey: idempotencyKey,
      );

  /// A new phone number, typed while sending a reminder.
  Future<void> updatePhone(PartyType type, String id, String phone) async {
    await _dio.put<dynamic>(_party(type, id), data: {'phone': phone});
  }
}
