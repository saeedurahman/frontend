
import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/register/data/repositories/register_repository_impl.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';

class _Auth implements AuthRepository {
  Map<String, dynamic>? sent;
  @override
  Future<Either<Failure, User>> registerBusiness(Map<String, dynamic> data) async {
    sent = data;
    return Right(_user);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Settings implements SettingsRepository {
  List<Map<String, dynamic>>? bulk;
  @override
  Future<Either<Failure, List<AppSettingModel>>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  ) async {
    bulk = settings;
    return const Right([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _user = User(
  id: 'u',
  email: 'o@x.pk',
  name: 'Owner',
  role: 'owner',
  businessId: 'b',
);

void main() {
  group('registration: "Does the price on your items already include tax?"', () {
    test('pharmacy and mart default to "price includes tax"', () {
      expect(TaxPricingChoice.defaultFor('pharmacy'), TaxPricingChoice.includesTax);
      expect(TaxPricingChoice.defaultFor('mart'), TaxPricingChoice.includesTax);
    });

    test('every other business type defaults to "tax is added on top"', () {
      for (final t in kBusinessTypes.map((b) => b.id)) {
        if (t == 'pharmacy' || t == 'mart') continue;
        expect(TaxPricingChoice.defaultFor(t), TaxPricingChoice.addedOnTop, reason: t);
      }
      expect(TaxPricingChoice.defaultFor(null), TaxPricingChoice.addedOnTop);
    });

    test('the pre-selected answer follows the business type until the owner picks', () {
      const mart = RegisterEntity(businessType: 'mart');
      expect(mart.effectiveTaxChoice, TaxPricingChoice.includesTax);
      final picked = mart.copyWith(taxChoice: TaxPricingChoice.addedOnTop);
      expect(picked.effectiveTaxChoice, TaxPricingChoice.addedOnTop);
    });

    test('three plain answers', () {
      expect(TaxPricingChoice.values.map((c) => c.label), [
        'Yes, the price includes tax',
        'No, tax is added on top',
        "I don't charge tax",
      ]);
    });

    test('prices_include_tax is sent with the registration', () {
      expect(
        const RegisterEntity(businessType: 'pharmacy').toJson()['prices_include_tax'],
        isTrue,
      );
      expect(
        const RegisterEntity(businessType: 'retail').toJson()['prices_include_tax'],
        isFalse,
      );
      expect(
        const RegisterEntity(
          businessType: 'mart',
          taxChoice: TaxPricingChoice.addedOnTop,
        ).toJson()['prices_include_tax'],
        isFalse,
      );
    });

    test('"I don\'t charge tax" turns tax.enabled off after registering', () async {
      final auth = _Auth();
      final settings = _Settings();
      final repo = RegisterRepositoryImpl(auth, settings);
      final result = await repo.register(
        const RegisterEntity(
          businessType: 'retail',
          taxChoice: TaxPricingChoice.noTax,
        ),
      );
      expect(result.isRight(), isTrue);
      expect(auth.sent!['prices_include_tax'], isFalse);
      expect(settings.bulk, [
        {
          'setting_key': 'tax.enabled',
          'setting_value': {'value': false},
        },
      ]);
    });

    test('other answers leave settings alone', () async {
      final settings = _Settings();
      final repo = RegisterRepositoryImpl(_Auth(), settings);
      await repo.register(const RegisterEntity(businessType: 'retail'));
      await repo.register(const RegisterEntity(businessType: 'mart'));
      expect(settings.bulk, isNull);
    });
  });

  group('local sales keep the tax snapshot (schema v8)', () {
    test('upgrading from v7 adds the snapshot columns with safe defaults', () async {
      final old = NativeDatabase.memory(
        setup: (raw) {
          // A v7 local_sales table without the tax columns, with a sale in it.
          raw.execute('''
            CREATE TABLE local_sales (
              id TEXT PRIMARY KEY, total_amount TEXT NOT NULL
            )''');
          raw.execute("INSERT INTO local_sales VALUES ('s1', '14.04')");
          raw.execute('PRAGMA user_version = 7');
        },
      );
      final db = AppDatabase.forTesting(old);
      addTearDown(db.close);

      final cols = await db.customSelect('PRAGMA table_info(local_sales)').get();
      final names = cols.map((r) => r.read<String>('name')).toSet();
      expect(
        names,
        containsAll([
          'net_amount',
          'exact_total',
          'rounding_amount',
          'tax_inclusive',
          'tax_rounding_mode',
          'tax_label',
        ]),
      );
      final row = await db
          .customSelect(
            'SELECT rounding_amount, tax_inclusive, tax_rounding_mode, tax_label '
            "FROM local_sales WHERE id = 's1'",
          )
          .getSingle();
      expect(row.read<String>('rounding_amount'), '0');
      expect(row.read<int>('tax_inclusive'), 0);
      expect(row.read<String>('tax_rounding_mode'), 'none');
      expect(row.data['tax_label'], isNull);
    });

    test('a fresh install has the columns too', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final cols = await db.customSelect('PRAGMA table_info(local_sales)').get();
      expect(
        cols.map((r) => r.read<String>('name')),
        containsAll(['tax_inclusive', 'tax_rounding_mode', 'rounding_amount']),
      );
    });
  });
}
