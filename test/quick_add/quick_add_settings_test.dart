// Settings > Quick Add (cubit + page) and who may open the Quick Add routes.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/route_permissions.dart';
import 'package:frantend/core/router/route_access_policy.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/quick_add/data/feedback_sound.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_settings_cubit.dart';
import 'package:frantend/features/quick_add/presentation/pages/quick_add_settings_page.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

import '../helpers/session_fixtures.dart';
import 'quick_add_fakes.dart';

class _NoRepo extends Fake implements SettingsRepository {}

class _Bulk extends BulkUpdateSettingsUseCase {
  _Bulk() : super(_NoRepo());

  final calls = <List<Map<String, dynamic>>>[];
  Failure? fail;

  @override
  Future<Either<Failure, List<AppSettingModel>>> call(List<Map<String, dynamic>> settings) async {
    calls.add(settings);
    final f = fail;
    return f == null ? const Right([]) : Left(f);
  }
}

class _Sound implements FeedbackSoundService {
  @override
  bool enabled = true;

  @override
  Future<void> setEnabled(bool value) async => enabled = value;

  @override
  void play(FeedbackSound sound) {}
}

Map<String, Object?> _asMap(List<Map<String, dynamic>> calls) => {
      for (final c in calls)
        c['setting_key'] as String: (c['setting_value'] as Map)['value'],
    };

void main() {
  late FakeQuickAddRepository repo;
  late _Bulk bulk;

  setUp(() {
    repo = FakeQuickAddRepository();
    bulk = _Bulk();
  });

  // Not awaited: under testWidgets the close() future needs a pump to finish.
  tearDown(() {
    unawaited(repo.dispose());
  });

  group('QuickAddSettingsCubit', () {
    test('loads the pulled settings and shows the example from the task', () async {
      final c = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      await c.load();
      expect(c.state.loading, isFalse);
      expect(c.state.example, 'Cost 80, margin 15% -> suggested price 92');
      expect(c.state.dirty, isFalse);
      await c.close();
    });

    test('the example follows margin and rounding live', () async {
      final c = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      await c.load();
      c.setMargin('20');
      expect(c.state.example, 'Cost 80, margin 20% -> suggested price 96');
      c.setRounding('nearest_5');
      expect(c.state.example, 'Cost 80, margin 20% -> suggested price 95');
      c.setRounding('none');
      c.setMargin('12.5');
      expect(c.state.example, 'Cost 80, margin 12.5% -> suggested price 90');
      expect(c.state.dirty, isTrue);
      await c.close();
    });

    test('a margin outside 0..1000 or not a number is flagged and not applied', () async {
      final c = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      await c.load();
      for (final bad in ['', 'abc', '-1', '1001']) {
        c.setMargin(bad);
        expect(c.state.marginValid, isFalse, reason: bad);
        expect(await c.save(), isFalse);
      }
      expect(bulk.calls, isEmpty);
      expect(c.state.draft.defaultMarginPercent, dec('15'));
      await c.close();
    });

    test('save sends every Quick Add key with the {"value": v} wrapper', () async {
      final c = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      await c.load();
      c
        ..setAskCost(false)
        ..setAskExpiry(true)
        ..setMargin('20')
        ..setRounding('nearest_10');
      expect(await c.save(), isTrue);

      expect(_asMap(bulk.calls.single), {
        'quick_add.ask_cost': false,
        'quick_add.ask_expiry': true,
        'pricing.default_margin_percent': 20,
        'pricing.suggested_price_rounding': 'nearest_10',
      });
      expect(c.state.justSaved, isTrue);
      expect(c.state.dirty, isFalse);
      await c.close();
    });

    test('a failed save keeps the edits and shows the message', () async {
      bulk.fail = const PermissionDeniedFailure('Only the owner can change this.');
      final c = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      await c.load();
      c.setAskCost(false);
      expect(await c.save(), isFalse);
      expect(c.state.error, 'Only the owner can change this.');
      expect(c.state.dirty, isTrue);
      expect(c.state.saving, isFalse);
      await c.close();
    });

    test('values pulled from the server are read (wrapped and plain)', () {
      final s = QuickAddSettings.fromMap({
        'quick_add.ask_cost': {'value': false},
        'quick_add.ask_expiry': true,
        'pricing.default_margin_percent': '25',
        'pricing.suggested_price_rounding': 'nearest_5',
        'inventory.require_batch': {'value': true},
      });
      expect(s.askCost, isFalse);
      expect(s.askExpiry, isTrue);
      expect(s.defaultMarginPercent, dec('25'));
      expect(s.rounding, 'nearest_5');
      expect(s.requireBatch, isTrue);
      // Garbage falls back to the server's defaults.
      final d = QuickAddSettings.fromMap({
        'pricing.default_margin_percent': 'many',
        'pricing.suggested_price_rounding': 'weird',
        'quick_add.ask_cost': 'yes',
      });
      expect(d.defaultMarginPercent, dec('15'));
      expect(d.askCost, isTrue);
      expect(d.rounding, 'nearest_1');
    });
  });

  group('QuickAddSettingsPage', () {
    Future<void> pump(WidgetTester tester, User user, _Sound sound) async {
      // The test font is far wider than the real one: cosmetic overflows are
      // ignored, any other framework error still fails the test.
      final prev = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('overflowed')) return;
        prev?.call(d);
      };
      addTearDown(() => FlutterError.onError = prev);
      tester.view.physicalSize = const Size(1200, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final cubit = QuickAddSettingsCubit(repository: repo, bulkUpdate: bulk);
      // The page's BlocProvider closes the cubit when it is unmounted.
      await tester.pumpWidget(
        BlocProvider<AccessCubit>.value(
          value: AccessCubit(
            fetchCurrentUser: () async => user,
            loadCachedUser: () async => user,
          )..apply(user),
          child: MaterialApp(
            home: Scaffold(body: QuickAddSettingsPage(cubit: cubit, sound: sound)),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();
    }

    testWidgets('the owner edits, sees the live example and saves', (tester) async {
      await pump(tester, makeUser(role: 'owner'), _Sound());
      expect(find.byKey(const ValueKey('qa-example')), findsOneWidget);
      expect(find.text('Cost 80, margin 15% -> suggested price 92'), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('qa-margin')), '20');
      await tester.pump();
      expect(find.text('Cost 80, margin 20% -> suggested price 96'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('qa-ask-cost')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('qa-save')));
      await tester.pump();
      await tester.pump();

      expect(bulk.calls, hasLength(1));
      expect(_asMap(bulk.calls.single)['quick_add.ask_cost'], false);
      expect(_asMap(bulk.calls.single)['pricing.default_margin_percent'], 20);
    });

    testWidgets('Save is off until something changed, and with a bad margin', (tester) async {
      await pump(tester, makeUser(role: 'owner'), _Sound());
      FilledButton save() => tester.widget<FilledButton>(find.byKey(const ValueKey('qa-save')));
      expect(save().onPressed, isNull);

      await tester.enterText(find.byKey(const ValueKey('qa-margin')), '5000');
      await tester.pump();
      expect(find.text('Type a number from 0 to 1000'), findsOneWidget);
      expect(save().onPressed, isNull);

      await tester.enterText(find.byKey(const ValueKey('qa-margin')), '30');
      await tester.pump();
      expect(save().onPressed, isNotNull);
    });

    testWidgets('someone who may not change settings sees them read-only', (tester) async {
      await pump(tester, makeUser(role: 'manager', keys: managerKeys), _Sound());
      expect(find.text('Only the owner can change these. You can see what is set.'), findsOneWidget);
      final tile = tester.widget<SwitchListTile>(find.byKey(const ValueKey('qa-ask-cost')));
      expect(tile.onChanged, isNull);
      expect(tester.widget<FilledButton>(find.byKey(const ValueKey('qa-save'))).onPressed, isNull);
      expect(tester.widget<TextField>(find.byKey(const ValueKey('qa-margin'))).enabled, isFalse);
    });

    testWidgets('the beep switch is per computer and works for everyone', (tester) async {
      final sound = _Sound();
      await pump(tester, makeUser(role: 'manager', keys: managerKeys), sound);
      expect(sound.enabled, isTrue);
      await tester.tap(find.byKey(const ValueKey('qa-sound')));
      await tester.pump();
      expect(sound.enabled, isFalse);
      expect(bulk.calls, isEmpty, reason: 'sound is not a backend setting');
    });
  });

  group('route permissions', () {
    String? redirect(String location, User user) => RouteAccessPolicy.redirect(
          location: location,
          isAuthenticated: true,
          isSubscriptionBlocked: false,
          access: accessOf(user),
          isKitchenOnly: false,
          homeRoute: RouteNames.dashboard,
        );

    test('the Quick Add routes are mapped to permissions', () {
      expect(RoutePermissions.requiredFor(RouteNames.productsQuickAdd), [Perm.productsCreate]);
      expect(RoutePermissions.requiredFor(RouteNames.productsCompleteDetails), [Perm.productsUpdate]);
      // They must not fall through to the product detail rule (":id").
      expect(RoutePermissions.requiredFor('/products/quick-add'), isNot([Perm.productsView]));
    });

    test('owner and manager may open Quick Add; a cashier is sent home', () {
      expect(redirect(RouteNames.productsQuickAdd, makeUser(role: 'owner')), isNull);
      expect(redirect(RouteNames.productsQuickAdd, makeUser(role: 'manager', keys: managerKeys)), isNull);
      expect(redirect(RouteNames.productsQuickAdd, makeUser(role: 'cashier', keys: cashierKeys)),
          isNotNull);
    });

    test('Complete details needs products.update', () {
      final creatorOnly = makeUser(role: 'staff', keys: [Perm.productsView, Perm.productsCreate]);
      expect(redirect(RouteNames.productsCompleteDetails, creatorOnly), isNotNull);
      expect(redirect(RouteNames.productsCompleteDetails, makeUser(role: 'manager', keys: managerKeys)), isNull);
    });
  });
}
