import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_line_model.freezed.dart';
part 'journal_line_model.g.dart';

@freezed
class JournalLineModel with _$JournalLineModel {
  const factory JournalLineModel({
    required String id,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_code') required String accountCode,
    @JsonKey(name: 'account_name') required String accountName,
    @JsonKey(name: 'debit_amount') required String debitAmount,
    @JsonKey(name: 'credit_amount') required String creditAmount,
    String? description,
    @JsonKey(name: 'line_order') @Default(0) int lineOrder,
  }) = _JournalLineModel;

  factory JournalLineModel.fromJson(Map<String, dynamic> json) =>
      _$JournalLineModelFromJson(json);
}
