import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  const PaginatedResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;

  @override
  List<Object?> get props => [items, total, page, pageSize];
}
