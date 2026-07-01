import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/complete_production_dialog.dart';

void main() {
  testWidgets('Complete button disabled until checkbox and valid qty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CompleteProductionDialog(
            productionNumber: 'PRD-0001',
            defaultQtyProduced: '10',
            maxQtyProduced: '10',
            availability: const [],
            isLoadingPreview: false,
            onQtyChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Complete production'), findsOneWidget);
    final completeButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Complete production'),
    );
    expect(completeButton.onPressed, isNull);

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckboxListTile &&
            widget.title is Text &&
            (widget.title! as Text).data!.contains('permanently adjust inventory'),
      ),
    );
    await tester.pumpAndSettle();

    final enabledButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Complete production'),
    );
    expect(enabledButton.onPressed, isNotNull);
  });
}
