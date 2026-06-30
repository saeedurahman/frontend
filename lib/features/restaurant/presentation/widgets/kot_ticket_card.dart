import 'package:flutter/material.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/kot_status_utils.dart';

class KotTicketCard extends StatelessWidget {
  const KotTicketCard({
    super.key,
    required this.ticket,
    required this.isUpdating,
    this.onAdvance,
  });

  final KotOrderModel ticket;
  final bool isUpdating;
  final VoidCallback? onAdvance;

  @override
  Widget build(BuildContext context) {
    final tableLabel = ticket.tableNumber != null && ticket.tableNumber!.isNotEmpty
        ? 'Table ${ticket.tableNumber}'
        : 'Walk-in';
    final elapsed = _elapsedLabel(ticket.firedAt);

    return Material(
      color: const Color(0xFF0F172A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onAdvance,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    tableLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '#${ticket.kotNumber}',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                elapsed,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
              if (ticket.notes != null && ticket.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ticket.notes!,
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              ...ticket.lines.map((line) => _LineRow(line: line)),
              if (onAdvance != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: isUpdating ? null : onAdvance,
                    style: FilledButton.styleFrom(
                      backgroundColor: KotStatusUtils.columnColor(ticket.status),
                      foregroundColor: Colors.white,
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            KotStatusUtils.advanceActionLabel(ticket.status),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _elapsedLabel(String firedAt) {
    final parsed = DateTime.tryParse(firedAt);
    if (parsed == null) return firedAt;
    final minutes = DateTime.now().difference(parsed.toLocal()).inMinutes;
    if (minutes < 1) return 'Just fired';
    if (minutes < 60) return '$minutes min ago';
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    return '${hours}h ${rem}m ago';
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line});

  final KotOrderLineModel line;

  @override
  Widget build(BuildContext context) {
    final modifiers = line.modifiersJson
        .whereType<Map>()
        .map((entry) => entry['name']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${line.qty}× ${line.productName}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (modifiers.isNotEmpty)
            Text(
              modifiers.join(', '),
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          if (line.kitchenNotes != null && line.kitchenNotes!.isNotEmpty)
            Text(
              line.kitchenNotes!,
              style: const TextStyle(
                color: Color(0xFFF472B6),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
