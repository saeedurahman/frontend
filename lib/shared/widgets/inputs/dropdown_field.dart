import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
  });

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}
