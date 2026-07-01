import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';

class FlatCoaNode {
  const FlatCoaNode({
    required this.account,
    required this.depth,
  });

  final ChartOfAccountModel account;
  final int depth;
}

/// Depth-first flatten of a chart-of-accounts tree.
List<FlatCoaNode> flattenCoaTree(List<ChartOfAccountModel> roots) {
  final result = <FlatCoaNode>[];

  void walk(List<ChartOfAccountModel> nodes, int depth) {
    for (final node in nodes) {
      result.add(FlatCoaNode(account: node, depth: depth));
      if (node.children.isNotEmpty) {
        walk(node.children, depth + 1);
      }
    }
  }

  walk(roots, 0);
  return result;
}

/// Label for parent/account pickers: indented code · name.
String coaIndentLabel({
  required String accountCode,
  required String accountName,
  int depth = 0,
}) {
  final prefix = depth <= 0 ? '' : '${'— ' * depth}';
  return '$prefix$accountCode · $accountName';
}

/// Returns [rootId] and all descendant account IDs (depth-first).
Set<String> descendantIds(
  String rootId,
  List<ChartOfAccountModel> roots,
) {
  final ids = <String>{};

  ChartOfAccountModel? findNode(
    String id,
    List<ChartOfAccountModel> nodes,
  ) {
    for (final node in nodes) {
      if (node.id == id) return node;
      final found = findNode(id, node.children);
      if (found != null) return found;
    }
    return null;
  }

  void collect(ChartOfAccountModel node) {
    ids.add(node.id);
    for (final child in node.children) {
      collect(child);
    }
  }

  final root = findNode(rootId, roots);
  if (root != null) {
    collect(root);
  }
  return ids;
}

/// Parent picker candidates: all accounts except [excludeIds].
List<FlatCoaNode> coaParentPickerOptions({
  required List<ChartOfAccountModel> roots,
  required Set<String> excludeIds,
}) {
  return flattenCoaTree(roots)
      .where((node) => !excludeIds.contains(node.account.id))
      .toList();
}
