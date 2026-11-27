// The aging bar: warm for money to pay, green to red for money to receive,
// parts in proportion, and the amounts under the pointer.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/khata_hub_page.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';

import '../helpers/khata_p1_fakes.dart';

/// The part of the bar for [age] inside [bar].
Finder _part(Finder bar, AgeBucket age) => find.descendant(
      of: bar,
      matching: find.byKey(ValueKey('aging-${age.apiValue}')),
    );

Color _colour(WidgetTester tester, Finder bar, AgeBucket age) => tester
    .widget<ColoredBox>(
      find.descendant(of: _part(bar, age), matching: find.byType(ColoredBox)),
    )
    .color;

double _width(WidgetTester tester, Finder bar, AgeBucket age) =>
    tester.getSize(_part(bar, age)).width;

/// The bar of one of the hub's two cards.
Finder _cardBar(PartyType type) => find.descendant(
      of: find.byKey(ValueKey('khata-total-${type.apiValue}')),
      matching: find.byType(AgingBar),
    );

Future<void> _hub(WidgetTester tester) async {
  final repo = FakeKhataRepository(
    customers: [hubRow('c1', 'Ahmed Khan', '45000')],
    suppliers: [hubRow('s1', 'National Foods', '62300')],
  );
  await pumpKhata(
    tester,
    KhataHubPage(
      createCubit: () => KhataHubCubit(repo),
      actions: KhataHubActions.app(repo),
      clock: () => khataNow,
    ),
    size: const Size(1440, 900),
  );
  await settle(tester);
}

bool _isWarm(Color c) => c.r > c.g && c.r > c.b;

void main() {
  testWidgets('"To receive" runs green, amber, orange, red', (tester) async {
    await _hub(tester);
    final bar = _cardBar(PartyType.customer);
    expect(
      [for (final age in AgeBucket.values) _colour(tester, bar, age)],
      [
        AppColors.success,
        const Color(0xFFD69E2E),
        AppColors.warning,
        AppColors.error,
      ],
    );
  });

  testWidgets('"To pay" stays orange and red, never green', (tester) async {
    await _hub(tester);
    final bar = _cardBar(PartyType.supplier);
    final colours = [
      for (final age in AgeBucket.values) _colour(tester, bar, age),
    ];
    expect(colours.every(_isWarm), isTrue, reason: '$colours');
    expect(colours.toSet(), hasLength(4), reason: 'each age is told apart');
    expect(colours, isNot(contains(AppColors.success)));
  });

  testWidgets('the parts are in proportion to the amounts', (tester) async {
    await _hub(tester);
    // overviewOf: 90,000 / 54,500 / 28,000 / 12,000.
    final receive = _cardBar(PartyType.customer);
    final total = tester.getSize(receive).width;
    for (final (age, share) in [
      (AgeBucket.upTo30, 90000 / 184500),
      (AgeBucket.upTo60, 54500 / 184500),
      (AgeBucket.upTo90, 28000 / 184500),
      (AgeBucket.over90, 12000 / 184500),
    ]) {
      expect(
        _width(tester, receive, age),
        closeTo(total * share, 5),
        reason: age.apiValue,
      );
    }
    // Nothing older than 60 days to pay: those parts take no room.
    final pay = _cardBar(PartyType.supplier);
    expect(_width(tester, pay, AgeBucket.upTo90), 0);
    expect(_width(tester, pay, AgeBucket.over90), 0);
    expect(
      _width(tester, pay, AgeBucket.upTo30) /
          _width(tester, pay, AgeBucket.upTo60),
      closeTo(40000 / 22300, 0.05),
    );
  });

  testWidgets('pointing at the bar lists every amount', (tester) async {
    await _hub(tester);
    const message = '0-30 days: Rs. 40,000.00\n'
        '31-60 days: Rs. 22,300.00\n'
        '61-90 days: Rs. 0.00\n'
        '90+ days: Rs. 0.00';
    expect(find.byTooltip(message), findsOneWidget);
    final bar = _cardBar(PartyType.supplier);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    // Just above the thin bar still counts.
    await mouse.moveTo(tester.getRect(bar).topCenter + const Offset(0, 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(message), findsOneWidget);
  });

  testWidgets('the age chips use the colours of the open tab', (tester) async {
    await _hub(tester);
    Color dot(AgeBucket age) => tester
        .widgetList<Container>(
          find.descendant(
            of: find.byKey(ValueKey('bucket-${age.apiValue}')),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .singleWhere((d) => d.shape == BoxShape.circle)
        .color!;
    expect(dot(AgeBucket.upTo30), AppColors.success);
    await tester.tap(find.byKey(const ValueKey('khata-total-supplier')));
    await settle(tester);
    expect(_isWarm(dot(AgeBucket.upTo30)), isTrue);
  });

  testWidgets('an empty side is a plain grey bar', (tester) async {
    await pumpKhata(
      tester,
      const AgingBar(type: PartyType.supplier, buckets: AgingBuckets.empty),
      size: const Size(800, 600),
    );
    await settle(tester);
    expect(find.byKey(const ValueKey('aging-0-30')), findsNothing);
    expect(
      find.byTooltip(AgingBar.summary(AgingBuckets.empty)),
      findsOneWidget,
    );
  });
}
