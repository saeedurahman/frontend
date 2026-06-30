import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/usecases/seed_pin_device_cache_usecase.dart';
import 'package:frantend/features/auth/domain/utils/pin_device_cache_roster_policy.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/users/domain/repositories/users_repository.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';

void main() {
  group('PinDeviceCacheData', () {
    test('round-trips through JSON with metadata fields', () {
      const original = PinDeviceCacheData(
        businessSlug: 'my-shop',
        lastFullRefreshAt: '2026-01-15T10:00:00.000Z',
        staff: [
          PinStaffEntry(
            id: 'u1',
            fullName: 'Ali',
            lastUsedAt: '2026-06-01T08:00:00.000Z',
          ),
          PinStaffEntry(id: 'u2', fullName: 'Sara'),
        ],
      );

      final restored = PinDeviceCacheData.fromJson(original.toJson());

      expect(restored.businessSlug, 'my-shop');
      expect(restored.lastFullRefreshAt, '2026-01-15T10:00:00.000Z');
      expect(restored.staff, hasLength(2));
      expect(restored.staff.first.lastUsedAt, '2026-06-01T08:00:00.000Z');
      expect(restored.staff.last.fullName, 'Sara');
      expect(restored.staff.last.lastUsedAt, isNull);
    });

    test('empty staff list deserializes', () {
      final data = PinDeviceCacheData.fromJson({
        'business_slug': 'shop',
        'staff': <dynamic>[],
      });
      expect(data.staff, isEmpty);
      expect(data.lastFullRefreshAt, isNull);
    });

    test('legacy JSON without new fields deserializes', () {
      final data = PinDeviceCacheData.fromJson({
        'business_slug': 'shop',
        'staff': [
          {'id': 'u1', 'full_name': 'Ali'},
        ],
      });
      expect(data.staff.single.lastUsedAt, isNull);
      expect(data.lastFullRefreshAt, isNull);
    });
  });

  group('mergeSelfPinRoster / applyMergeSelfCap', () {
    final now = DateTime.utc(2026, 6, 29, 12);

    test('upserts current user and sets lastUsedAt', () {
      final roster = mergeSelfPinRoster(
        existing: const [
          PinStaffEntry(id: 'other', fullName: 'Other'),
        ],
        userId: 'cashier',
        userName: 'Cashier One',
        now: now,
      );

      expect(roster, hasLength(2));
      expect(
        roster.firstWhere((e) => e.id == 'cashier').lastUsedAt,
        now.toIso8601String(),
      );
    });

    test('caps at 30 evicting oldest by lastUsedAt', () {
      final existing = List.generate(
        30,
        (i) => PinStaffEntry(
          id: 'user-$i',
          fullName: 'User $i',
          lastUsedAt: DateTime.utc(2026, 1, i + 1).toIso8601String(),
        ),
      );

      final roster = mergeSelfPinRoster(
        existing: existing,
        userId: 'new-cashier',
        userName: 'New Cashier',
        now: now,
      );

      expect(roster, hasLength(30));
      expect(roster.any((e) => e.id == 'new-cashier'), isTrue);
      expect(roster.any((e) => e.id == 'user-0'), isFalse);
    });

    test('never evicts the user who just logged in even when over cap', () {
      final existing = List.generate(
        30,
        (i) => PinStaffEntry(
          id: 'user-$i',
          fullName: 'User $i',
          lastUsedAt: DateTime.utc(2026, 6, i + 1).toIso8601String(),
        ),
      );

      final roster = mergeSelfPinRoster(
        existing: existing,
        userId: 'user-0',
        userName: 'User Zero Updated',
        now: DateTime.utc(2026, 1, 1),
      );

      expect(roster, hasLength(30));
      expect(roster.any((e) => e.id == 'user-0'), isTrue);
      expect(
        roster.firstWhere((e) => e.id == 'user-0').fullName,
        'User Zero Updated',
      );
    });

    test('legacy entries without lastUsedAt are evicted first', () {
      final existing = [
        const PinStaffEntry(id: 'legacy-a', fullName: 'Legacy A'),
        const PinStaffEntry(id: 'legacy-b', fullName: 'Legacy B'),
        PinStaffEntry(
          id: 'recent',
          fullName: 'Recent',
          lastUsedAt: DateTime.utc(2026, 6, 20).toIso8601String(),
        ),
        ...List.generate(
          28,
          (i) => PinStaffEntry(
            id: 'filled-$i',
            fullName: 'Filled $i',
            lastUsedAt: DateTime.utc(2026, 2, i + 1).toIso8601String(),
          ),
        ),
      ];

      final roster = mergeSelfPinRoster(
        existing: existing,
        userId: 'incoming',
        userName: 'Incoming',
        now: now,
      );

      expect(roster, hasLength(30));
      expect(roster.any((e) => e.id == 'incoming'), isTrue);
      expect(roster.any((e) => e.id == 'legacy-a'), isFalse);
      expect(roster.any((e) => e.id == 'legacy-b'), isFalse);
      expect(roster.any((e) => e.id == 'recent'), isTrue);
    });
  });

  group('SeedPinDeviceCacheUseCase', () {
    late _MemoryPinDeviceCache cache;
    late _StubGetUsersUseCase getUsers;

    const manager = User(
      id: 'mgr-1',
      email: 'mgr@test.com',
      name: 'Manager',
      role: 'owner',
      businessSlug: 'test-shop',
      permissionKeys: ['users.view'],
    );

    const cashier = User(
      id: 'cashier-1',
      email: 'c@test.com',
      name: 'Cashier',
      role: 'cashier',
      businessSlug: 'test-shop',
      permissionKeys: ['sales.create'],
    );

    setUp(() {
      cache = _MemoryPinDeviceCache();
      getUsers = _StubGetUsersUseCase();
    });

    SeedPinDeviceCacheUseCase buildUseCase() =>
        SeedPinDeviceCacheUseCase(cache, getUsers);

    test('full refresh replaces roster with active users only', () async {
      cache.stored = PinDeviceCacheData(
        businessSlug: 'old-slug',
        staff: const [
          PinStaffEntry(id: 'stale', fullName: 'Stale Person'),
          PinStaffEntry(id: 'gone', fullName: 'Gone Person'),
        ],
        lastFullRefreshAt: '2026-01-01T00:00:00.000Z',
      );

      getUsers.result = Right([
        const StaffUserModel(id: 'active-1', fullName: 'Zara'),
        const StaffUserModel(id: 'active-2', fullName: 'Ali'),
        const StaffUserModel(
          id: 'inactive-1',
          fullName: 'Inactive',
          isActive: false,
        ),
      ]);

      await buildUseCase()(manager);

      expect(cache.stored!.businessSlug, 'test-shop');
      expect(cache.stored!.staff.map((e) => e.id), ['active-2', 'active-1']);
      expect(cache.stored!.staff.any((e) => e.id == 'stale'), isFalse);
      expect(cache.stored!.lastFullRefreshAt, isNotNull);
      expect(cache.stored!.lastFullRefreshAt, isNot('2026-01-01T00:00:00.000Z'));
    });

    test('full refresh failure preserves existing roster unchanged', () async {
      const priorStaff = [
        PinStaffEntry(id: 'keep-1', fullName: 'Keep One'),
        PinStaffEntry(
          id: 'keep-2',
          fullName: 'Keep Two',
          lastUsedAt: '2026-05-01T00:00:00.000Z',
        ),
      ];
      cache.stored = const PinDeviceCacheData(
        businessSlug: 'old-slug',
        staff: priorStaff,
        lastFullRefreshAt: '2026-01-01T00:00:00.000Z',
      );

      getUsers.result = const Left(ServerFailure('offline'));

      await buildUseCase()(manager);

      expect(cache.stored!.businessSlug, 'test-shop');
      expect(cache.stored!.staff, priorStaff);
      expect(cache.stored!.lastFullRefreshAt, '2026-01-01T00:00:00.000Z');
    });

    test('merge-self upserts cashier without removing others', () async {
      cache.stored = const PinDeviceCacheData(
        businessSlug: 'test-shop',
        staff: [
          PinStaffEntry(id: 'other', fullName: 'Other'),
        ],
      );

      await buildUseCase()(cashier);

      expect(cache.stored!.staff, hasLength(2));
      expect(cache.stored!.staff.any((e) => e.id == 'cashier-1'), isTrue);
      expect(cache.stored!.staff.any((e) => e.id == 'other'), isTrue);
      expect(
        cache.stored!.staff.firstWhere((e) => e.id == 'cashier-1').lastUsedAt,
        isNotNull,
      );
      expect(cache.stored!.lastFullRefreshAt, isNull);
    });
  });
}

class _MemoryPinDeviceCache implements PinDeviceCache {
  PinDeviceCacheData? stored;

  @override
  Future<PinDeviceCacheData?> read() async => stored;

  @override
  Future<void> write(PinDeviceCacheData data) async => stored = data;
}

class _StubGetUsersUseCase extends GetUsersUseCase {
  _StubGetUsersUseCase() : super(_ThrowingUsersRepository());

  Either<Failure, List<StaffUserModel>> result = const Right([]);

  @override
  Future<Either<Failure, List<StaffUserModel>>> call({String? role}) async =>
      result;
}

class _ThrowingUsersRepository implements UsersRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
