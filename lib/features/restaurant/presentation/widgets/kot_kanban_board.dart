import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_cubit.dart';
import 'package:frantend/features/restaurant/presentation/cubit/kitchen_display_state.dart';
import 'package:frantend/features/restaurant/presentation/utils/kot_status_utils.dart';
import 'package:frantend/features/restaurant/presentation/widgets/kot_ticket_card.dart';

class KotKanbanBoard extends StatelessWidget {
  const KotKanbanBoard({super.key, required this.state});

  final KitchenDisplayState state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<KitchenDisplayCubit>().refresh(),
      color: const Color(0xFF22C55E),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final status in const ['pending', 'preparing', 'ready'])
            Expanded(
              child: _KotColumn(
                status: status,
                tickets: state.ticketsForColumn(status),
                isUpdating: state.isUpdatingStatus,
                updatingTicketId: state.updatingTicketId,
              ),
            ),
        ],
      ),
    );
  }
}

class _KotColumn extends StatelessWidget {
  const _KotColumn({
    required this.status,
    required this.tickets,
    required this.isUpdating,
    required this.updatingTicketId,
  });

  final String status;
  final List<KotOrderModel> tickets;
  final bool isUpdating;
  final String? updatingTicketId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KitchenDisplayCubit>();
    final color = KotStatusUtils.columnColor(status);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  KotStatusUtils.label(status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${tickets.length}',
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: tickets.isEmpty
                ? const Center(
                    child: Text(
                      'No tickets',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KotTicketCard(
                          ticket: ticket,
                          isUpdating:
                              isUpdating && updatingTicketId == ticket.id,
                          onAdvance: KotStatusUtils.nextStatus(ticket.status) ==
                                  null
                              ? null
                              : () async {
                                  final error =
                                      await cubit.advanceTicketStatus(ticket.id);
                                  if (error != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error)),
                                    );
                                  }
                                },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
