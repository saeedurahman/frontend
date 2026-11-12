import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/shared/widgets/quantity/quantity_calculator_sheet.dart';

Decimal d(String v) => Decimal.parse(v);

/// A page with one button that opens the calculator and keeps its result.
class _Host extends StatefulWidget {
  const _Host(this.config);
  final QuantityCalculatorConfig config;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final results = <QuantityCalculatorResult?>[];
  int opened = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            opened++;
            results.add(await QuantityCalculatorSheet.show(context, widget.config));
          },
          child: const Text('open'),
        ),
      ),
    );
  }
}

const _basic = QuantityCalculatorConfig(title: 'Rice 5kg');

Future<_HostState> _open(
  WidgetTester tester,
  QuantityCalculatorConfig config, {
  Size size = const Size(1280, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: _Host(config)));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return tester.state<_HostState>(find.byType(_Host));
}

Future<void> _tapKeys(WidgetTester tester, List<String> keys) async {
  for (final k in keys) {
    await tester.tap(find.byKey(Key('qty-key-$k')));
    await tester.pump();
  }
}

Future<void> _press(WidgetTester tester, List<LogicalKeyboardKey> keys) async {
  for (final k in keys) {
    await tester.sendKeyEvent(k);
    await tester.pump();
  }
}

String _text(WidgetTester tester, String key) {
  final finder = find.byKey(Key(key));
  final widget = tester.widget(finder);
  if (widget is Text) return widget.data!;
  return tester
      .widget<Text>(find.descendant(of: finder, matching: find.byType(Text)))
      .data!;
}

Future<void> _escape(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
}

void main() {
  group('opening', () {
    testWidgets('shows the product, unit price, stock, chips and keypad',
        (tester) async {
      await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Rice 5kg',
          subtitle: 'Large',
          unitPrice: d('100'),
          stock: d('25'),
          unitLabel: 'pcs',
        ),
      );

      expect(find.text('Rice 5kg (Large)'), findsOneWidget);
      expect(_text(tester, 'qty-price'), 'Rs. 100');
      expect(_text(tester, 'qty-stock'), 'In stock: 25 pcs');
      expect(_text(tester, 'qty-display'), '1', reason: 'empty input means 1');
      expect(_text(tester, 'qty-total'), 'Rs. 100');
      for (final q in [1, 2, 3, 5, 10]) {
        expect(find.byKey(Key('qty-chip-$q')), findsOneWidget);
      }
      for (final k in [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'dot', 'back', 'x', 'plus', 'minus', 'div',
      ]) {
        expect(find.byKey(Key('qty-key-$k')), findsOneWidget, reason: k);
      }
      expect(find.text('Add'), findsOneWidget);
      expect(find.byKey(const Key('qty-remove')), findsNothing);
    });

    testWidgets('wide window: a centered dialog about 420 px wide',
        (tester) async {
      await _open(tester, _basic);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      expect(tester.getSize(find.byType(QuantityCalculatorSheet)).width, 420);
    });

    testWidgets('narrow width (< 600): a modal bottom sheet', (tester) async {
      await _open(tester, _basic, size: const Size(390, 900));
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(tester.getSize(find.byType(QuantityCalculatorSheet)).width, 390);
    });

    testWidgets('keys are large touch targets (at least 56 px)', (tester) async {
      for (final size in [const Size(1280, 900), const Size(390, 900)]) {
        await _open(tester, _basic, size: size);
        for (final k in ['7', '0', 'x', 'back']) {
          final key = tester.getSize(find.byKey(Key('qty-key-$k')));
          expect(key.height, greaterThanOrEqualTo(56), reason: '$k at $size');
          expect(key.width, greaterThanOrEqualTo(56), reason: '$k at $size');
        }
        expect(
          tester.getSize(find.byKey(const Key('qty-confirm'))).height,
          greaterThanOrEqualTo(56),
        );
        await _escape(tester);
      }
    });

    testWidgets('low, zero and negative stock are called out', (tester) async {
      await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Tea',
          stock: d('2'),
          lowStockLevel: d('5'),
        ),
      );
      expect(_text(tester, 'qty-stock'), 'Low stock: 2 left');
      await _escape(tester);

      await _open(tester, QuantityCalculatorConfig(title: 'Tea', stock: d('0')));
      expect(_text(tester, 'qty-stock'), 'Out of stock');
      await _escape(tester);

      await _open(tester, QuantityCalculatorConfig(title: 'Tea', stock: d('-3')));
      expect(_text(tester, 'qty-stock'), 'Stock: -3 (negative)');
    });
  });

  group('Add', () {
    testWidgets('empty input + Add = quantity 1, and the popup closes',
        (tester) async {
      final host = await _open(tester, _basic);
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();

      expect(find.byType(QuantityCalculatorSheet), findsNothing);
      expect(host.results.single!.action, QuantityCalculatorAction.confirm);
      expect(host.results.single!.quantity, Decimal.one);
      expect(host.results.single!.unitPrice, isNull);
    });

    testWidgets('keypad: 3 × 3 shows the result and the live total',
        (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(title: 'Rice', unitPrice: d('100')),
      );
      await _tapKeys(tester, ['3', 'x', '3']);

      expect(_text(tester, 'qty-display'), '3×3');
      expect(_text(tester, 'qty-result'), '= 9');
      expect(_text(tester, 'qty-total'), 'Rs. 900');

      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('9'));
    });

    testWidgets('backspace, operator replacement and quick chips',
        (tester) async {
      final host = await _open(tester, _basic);
      await _tapKeys(tester, ['1', '2', 'plus', 'minus', '6', '7', 'back']);
      expect(_text(tester, 'qty-display'), '12-6');

      await tester.tap(find.byKey(const Key('qty-chip-5')));
      await tester.pump();
      expect(_text(tester, 'qty-display'), '5', reason: 'a chip sets the quantity');

      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('5'));
    });

    testWidgets('a fast double tap on Add adds once', (tester) async {
      final host = await _open(tester, _basic);
      await _tapKeys(tester, ['4']);
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.tap(find.byKey(const Key('qty-confirm')), warnIfMissed: false);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(host.results, hasLength(1));
      expect(host.results.single!.quantity, d('4'));
      expect(find.text('open'), findsOneWidget, reason: 'only the popup closed');
    });

    testWidgets('the total uses the caller\'s tax and discount rules',
        (tester) async {
      // 10% line discount and 5% tax, computed by the cart's PricingEngine.
      final line = CartItemModel(
        productId: 'p1',
        productName: 'Rice',
        unitPrice: d('100'),
        qty: Decimal.one,
        itemDiscountPct: d('10'),
        taxRate: d('5'),
      );
      await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Rice',
          unitPrice: d('100'),
          lineTotal: (qty, price) =>
              line.copyWith(qty: qty, unitPrice: price).lineTotal,
          formatMoney: (v) => 'Rs ${v.toStringAsFixed(2)}',
        ),
      );
      // 1 x 100 - 10% = 90, + 5% tax = 94.50
      expect(_text(tester, 'qty-total'), 'Rs 94.50');

      await _tapKeys(tester, ['3']);
      // 3 x 100 = 300 - 30 = 270, + 13.50 tax = 283.50
      expect(_text(tester, 'qty-total'), 'Rs 283.50');
    });
  });

  group('validation', () {
    testWidgets('zero is refused with an inline error, popup stays open',
        (tester) async {
      final host = await _open(tester, _basic);
      await _tapKeys(tester, ['0']);
      expect(find.byKey(const Key('qty-error')), findsNothing);

      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();

      expect(_text(tester, 'qty-error'), 'Quantity must be greater than 0');
      expect(find.byType(QuantityCalculatorSheet), findsOneWidget);
      expect(host.results, isEmpty);

      await _tapKeys(tester, ['5']);
      expect(find.byKey(const Key('qty-error')), findsNothing,
          reason: 'typing clears the error');
    });

    testWidgets('whole-number units refuse 10 ÷ 4; decimal units accept it',
        (tester) async {
      var host = await _open(tester, _basic);
      await _tapKeys(tester, ['1', '0', 'div', '4']);
      expect(_text(tester, 'qty-error'), 'Whole numbers only for this item');
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results, isEmpty);
      await _escape(tester);

      host = await _open(
        tester,
        const QuantityCalculatorConfig(
          title: 'Sugar',
          allowDecimal: true,
          unitLabel: 'kg',
        ),
      );
      await _tapKeys(tester, ['1', '0', 'div', '4']);
      expect(_text(tester, 'qty-result'), '= 2.5 kg');
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.last!.quantity, d('2.5'));
    });

    testWidgets('decimal units take at most three decimal places',
        (tester) async {
      await _open(
        tester,
        const QuantityCalculatorConfig(title: 'Sugar', allowDecimal: true),
      );
      await _tapKeys(tester, ['dot', '1', '2', '5', '9', 'dot']);
      expect(_text(tester, 'qty-display'), '0.125');
    });

    testWidgets('absurd quantities are refused with a message', (tester) async {
      final host = await _open(tester, _basic);
      await _tapKeys(tester, ['1', '0', '0', '0', '0', '0', '0']);
      expect(_text(tester, 'qty-error'), contains('too large'));
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results, isEmpty);
    });

    testWidgets('division by zero is an error on Add', (tester) async {
      final host = await _open(tester, _basic);
      await _tapKeys(tester, ['8', 'div', '0']);
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(_text(tester, 'qty-error'), 'Cannot divide by zero');
      expect(host.results, isEmpty);
    });

    testWidgets('more than the stock is a warning, not a block',
        (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(title: 'Tea', stock: d('3')),
      );
      await _tapKeys(tester, ['5']);
      expect(_text(tester, 'qty-stock-warning'), 'More than the 3 in stock');

      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('5'), reason: 'the sale goes on');
    });

    testWidgets('it blocks only when the owner forbids selling below stock',
        (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Tea',
          stock: d('3'),
          blockBelowStock: true,
        ),
      );
      await _tapKeys(tester, ['5']);
      expect(_text(tester, 'qty-error'), 'Only 3 in stock');
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results, isEmpty);

      await _tapKeys(tester, ['back', '3']);
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('3'));
    });
  });

  group('keyboard', () {
    testWidgets('the first key press works; Enter adds', (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(title: 'Rice', unitPrice: d('100')),
      );
      // No tap inside the popup first: it must already have the focus.
      await _press(tester, [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.numpadAdd,
        LogicalKeyboardKey.numpad6,
      ]);
      expect(_text(tester, 'qty-display'), '12+6');
      expect(_text(tester, 'qty-total'), 'Rs. 1,800');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(QuantityCalculatorSheet), findsNothing);
      expect(host.results.single!.quantity, d('18'));
    });

    testWidgets('x, -, /, ., Backspace and numpad Enter', (tester) async {
      final host = await _open(
        tester,
        const QuantityCalculatorConfig(title: 'Sugar', allowDecimal: true),
      );
      await _press(tester, [
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.keyX,
        LogicalKeyboardKey.digit3,
      ]);
      expect(_text(tester, 'qty-display'), '3×3');

      await _press(tester, [
        LogicalKeyboardKey.backspace,
        LogicalKeyboardKey.backspace,
        LogicalKeyboardKey.minus,
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.slash,
        LogicalKeyboardKey.digit4,
      ]);
      expect(_text(tester, 'qty-display'), '3-1÷4');

      await _press(tester, [
        LogicalKeyboardKey.delete, // clears
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.period,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.numpadMultiply,
        LogicalKeyboardKey.digit2,
      ]);
      expect(_text(tester, 'qty-display'), '1.5×2');

      await tester.sendKeyEvent(LogicalKeyboardKey.numpadEnter);
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('3'));
    });

    testWidgets('Esc cancels: nothing is returned', (tester) async {
      final host = await _open(tester, _basic);
      await _press(tester, [LogicalKeyboardKey.digit7]);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(QuantityCalculatorSheet), findsNothing);
      expect(host.results.single, isNull);
    });

    testWidgets('the close button cancels too', (tester) async {
      final host = await _open(tester, _basic);
      await tester.tap(find.byKey(const Key('qty-close')));
      await tester.pumpAndSettle();
      expect(host.results.single, isNull);
    });
  });

  group('edit mode', () {
    final config = QuantityCalculatorConfig(
      title: 'Rice',
      unitPrice: d('100'),
      initialQuantity: d('4'),
    );

    testWidgets('opens with the current quantity; Update and Remove are offered',
        (tester) async {
      await _open(tester, config);
      expect(_text(tester, 'qty-display'), '4');
      expect(_text(tester, 'qty-total'), 'Rs. 400');
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Add'), findsNothing);
      expect(find.byKey(const Key('qty-remove')), findsOneWidget);
    });

    testWidgets('typing replaces the quantity; Update returns the new one',
        (tester) async {
      final host = await _open(tester, config);
      await _tapKeys(tester, ['1', '2']);
      expect(_text(tester, 'qty-display'), '12', reason: 'not "412"');
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(host.results.single!.action, QuantityCalculatorAction.confirm);
      expect(host.results.single!.quantity, d('12'));
    });

    testWidgets('an operator continues from the current quantity',
        (tester) async {
      final host = await _open(tester, config);
      await _tapKeys(tester, ['plus', '6']);
      expect(_text(tester, 'qty-display'), '4+6');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('10'));
    });

    testWidgets('Remove returns the remove action', (tester) async {
      final host = await _open(tester, config);
      await tester.tap(find.byKey(const Key('qty-remove')));
      await tester.pumpAndSettle();
      expect(find.byType(QuantityCalculatorSheet), findsNothing);
      expect(host.results.single!.action, QuantityCalculatorAction.remove);
      expect(host.results.single!.quantity, isNull);
    });
  });

  group('price', () {
    testWidgets('without the permission the price cannot be edited',
        (tester) async {
      await _open(
        tester,
        QuantityCalculatorConfig(title: 'Rice', unitPrice: d('100')),
      );
      expect(find.byKey(const Key('qty-price-edit')), findsNothing);
    });

    testWidgets('with it: tap the price, type, Enter, then the quantity',
        (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Rice',
          unitPrice: d('100'),
          canEditPrice: true,
        ),
      );
      await _tapKeys(tester, ['2']);
      await tester.tap(find.byKey(const Key('qty-price-edit')));
      await tester.pump();
      expect(find.text('New price'), findsOneWidget);
      expect(find.text('Set price'), findsOneWidget);

      await _press(tester, [
        LogicalKeyboardKey.digit8,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.enter, // confirms the price only
      ]);
      expect(find.byType(QuantityCalculatorSheet), findsOneWidget);
      expect(_text(tester, 'qty-price'), 'Rs. 85');
      expect(_text(tester, 'qty-display'), '2', reason: 'quantity kept');
      expect(_text(tester, 'qty-total'), 'Rs. 170');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(host.results.single!.quantity, d('2'));
      expect(host.results.single!.unitPrice, d('85'));
    });

    testWidgets('Esc while typing a price keeps the list price', (tester) async {
      final host = await _open(
        tester,
        QuantityCalculatorConfig(
          title: 'Rice',
          unitPrice: d('100'),
          canEditPrice: true,
        ),
      );
      await tester.tap(find.byKey(const Key('qty-price-edit')));
      await tester.pump();
      await _press(tester, [LogicalKeyboardKey.digit9, LogicalKeyboardKey.escape]);
      expect(find.byType(QuantityCalculatorSheet), findsOneWidget);
      expect(_text(tester, 'qty-price'), 'Rs. 100');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(host.results.single!.unitPrice, isNull);
    });
  });
}
