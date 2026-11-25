import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_state.dart';

enum SummaryChoice { addMore, review }

/// "42 added, 8 updated, 2 need attention".
Future<SummaryChoice?> showQuickAddSummary(BuildContext context, QuickAddSummary summary) {
  return showDialog<SummaryChoice>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      key: const ValueKey('quick-add-summary'),
      icon: Icon(
        summary.needAttention > 0 ? Icons.warning_amber_rounded : Icons.check_circle,
        size: 40,
        color: summary.needAttention > 0 ? AppColors.warning : AppColors.success,
      ),
      title: Text(summary.headline, textAlign: TextAlign.center),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (summary.replayed)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'This list was already saved earlier. Nothing was added twice.',
                  textAlign: TextAlign.center,
                ),
              ),
            if (summary.paidNote != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  summary.paidNote!,
                  key: const ValueKey('quick-add-paid-note'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            if (summary.needAttention > 0)
              const Text(
                'The items that need attention stay in your list, marked in red. '
                'Fix them and tap Save all again.',
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Your stock and prices are up to date.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, SummaryChoice.addMore),
          child: const Text('Add more'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, SummaryChoice.review),
          child: const Text('Review products'),
        ),
      ],
    ),
  );
}

/// "Resume your Quick Add draft (37 items)". True = resume, false = start fresh.
Future<bool?> showQuickAddResume(BuildContext context, int items) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      key: const ValueKey('quick-add-resume'),
      title: Text('Resume your Quick Add draft ($items ${items == 1 ? 'item' : 'items'})'),
      content: const Text(
        'You scanned these items earlier but did not save them. '
        'Do you want to carry on where you stopped?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Start fresh'),
        ),
        FilledButton(
          autofocus: true,
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Resume'),
        ),
      ],
    ),
  );
}

/// Leaving with unsaved items: the draft is kept either way.
Future<bool> confirmLeaveQuickAdd(BuildContext context, int items) async {
  final leave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Leave Quick Add?'),
      content: Text(
        'You have $items ${items == 1 ? 'item' : 'items'} that ${items == 1 ? 'is' : 'are'} not saved yet. '
        'They stay on this computer as a draft, so you can resume later.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Stay')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Leave')),
      ],
    ),
  );
  return leave ?? false;
}

Future<bool> confirmClearList(BuildContext context, int items) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Clear the whole list?'),
      content: Text('This removes all $items items from the list. This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Clear list'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
