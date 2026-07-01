import 'package:flutter/material.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';

class AccountParentPicker extends StatelessWidget {
  const AccountParentPicker({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  final String? value;
  final List<FlatCoaNode> options;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final resolvedValue =
        value != null && options.any((o) => o.account.id == value) ? value : null;

    return DropdownButtonFormField<String?>(
      value: resolvedValue,
      decoration: InputDecoration(
        labelText: 'Parent account',
        helperText: 'Optional — groups this account under a parent',
        errorText: errorText,
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('None (top level)'),
        ),
        ...options.map(
          (node) => DropdownMenuItem<String?>(
            value: node.account.id,
            child: Text(
              coaIndentLabel(
                accountCode: node.account.accountCode,
                accountName: node.account.accountName,
                depth: node.depth,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
