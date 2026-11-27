// The sales cards of the Cash Register and Shift Report screens.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';

void main() {
  /// The amount shown under the card called [title].
  String amountOn(WidgetTester tester, String title) {
    final card = find.ancestor(of: find.text(title), matching: find.byType(Card));
    final texts = tester.widgetList<Text>(
      find.descendant(of: card, matching: find.byType(Text)),
    );
    return texts.last.data!;
  }

  testWidgets('credit sales have their own card, "Other" keeps the rest',
      (tester) async {
    final summary = ShiftSummaryModel.fromJson({
      'total_cash_sales': '100.00',
      'total_card_sales': '20.00',
      'total_wallet_sales': '30.00',
      'credit_sales': '117.00',
      'total_other_sales': '8.00',
    });
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: ShiftSummaryBreakdown(summary: summary)),
      ),
    ));
    expect(amountOn(tester, 'Credit Sales'), contains('117'));
    expect(amountOn(tester, 'Other Sales'), contains('8'));
    expect(amountOn(tester, 'Other Sales'), isNot(contains('117')));
    expect(summary.totalSalesAmount.toString(), '275');
  });

  test('a server without the field reads as no credit sales', () {
    expect(ShiftSummaryModel.fromJson(const {}).creditSales, '0');
  });
}
