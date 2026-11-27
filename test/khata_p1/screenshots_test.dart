// Pictures of the Khata hub and the statement preview, for people to look at:
// build/test_samples/khata_p1/. Fails if a screen stops drawing.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/platform/file_share_service.dart';
import 'package:frantend/core/theme/app_theme.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_statement_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/khata_hub_page.dart';
import 'package:frantend/features/khata/presentation/pages/khata_statement_page.dart';

import '../helpers/khata_p1_fakes.dart';
import '../helpers/sample_output.dart';

FakeKhataRepository _repository() => FakeKhataRepository(
      customers: [
        hubRow('c1', 'Ahmed Khan', '45000',
            age: 45, remindedAt: khataNow.subtract(const Duration(days: 3))),
        hubRow('c2', 'Bilal Traders', '120000',
            age: 12,
            promiseDate: DateTime(2026, 12, 15),
            promiseAmount: '50000'),
        hubRow('c3', 'Zahid Ullah', '8000', age: 130, phone: null),
        hubRow('c4', 'Madina Sweets', '6500', age: 72),
        hubRow('c5', 'Sana Boutique', '5000', age: 4),
      ],
      suppliers: [hubRow('s1', 'National Foods', '62300', age: 33)],
    )..statementAnswer =
        (call) => Right(statementJson(detail: call.detail));

Future<void> _picture(
  WidgetTester tester,
  String name,
  Size size,
  Widget page,
) async {
  setWindow(tester, size);
  final key = GlobalKey();
  final access = accessCubitFor(ownerUser());
  addTearDown(access.close);
  final theme = AppTheme.light;
  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: BlocProvider.value(
        value: access,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.copyWith(
            textTheme: theme.textTheme.apply(fontFamily: 'Inter'),
          ),
          home: Scaffold(
            body: Padding(padding: const EdgeInsets.all(24), child: page),
          ),
        ),
      ),
    ),
  );
  await settle(tester, 20);
  expect(tester.takeException(), isNull);

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  expect(bytes!.length, greaterThan(10000), reason: 'the screen drew');
  final dir = sampleOutputDir('khata_p1');
  File('${dir.path}/$name.png').writeAsBytesSync(bytes);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Real letters and icons instead of the test placeholder font.
    for (final family in ['Inter', 'Roboto']) {
      final loader = FontLoader(family)
        ..addFont(rootBundle.load('assets/fonts/Inter-400.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Inter-700.ttf'));
      await loader.load();
    }
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  for (final size in const [Size(1440, 900), Size(760, 900)]) {
    testWidgets('khata hub at ${size.width.toInt()} px', (tester) async {
      final repo = _repository();
      await _picture(
        tester,
        'khata_hub_${size.width.toInt()}',
        size,
        KhataHubPage(
          createCubit: () => KhataHubCubit(repo),
          actions: KhataHubActions(
            open: (_, __, ___, ____) {},
            remind: (_, __, ___, ____) {},
            pay: (_, __, ___, ____) {},
            statement: (_, __, ___, ____) {},
            promise: (_, __, ___, ____) {},
          ),
          clock: () => khataNow,
        ),
      );
    });
  }

  for (final (name, size) in const [
    ('statement_preview_1366', Size(1366, 1200)),
    ('statement_preview_800', Size(800, 1500)),
  ]) {
    testWidgets(name, (tester) async {
      final repo = _repository();
      final files = FakeFiles();
      await _picture(
        tester,
        name,
        size,
        KhataStatementPage(
          partyType: PartyType.customer,
          partyId: 'c1',
          repository: repo,
          createCubit: () => KhataStatementCubit(
            repository: repo,
            files: files,
            printer: FakePrinter(),
            share: DesktopFileShareService(files),
            partyType: PartyType.customer,
            partyId: 'c1',
            clock: () => khataNow,
          ),
        ),
      );
    });
  }
}
