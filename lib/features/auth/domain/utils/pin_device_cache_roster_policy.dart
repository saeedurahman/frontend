import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';

const pinDeviceMergeSelfCap = 30;

List<PinStaffEntry> activeUsersToPinRoster(List<StaffUserModel> users) {
  final staff = users
      .where((u) => u.isActive)
      .map((u) => PinStaffEntry(id: u.id, fullName: u.fullName))
      .toList()
    ..sort((a, b) => a.fullName.compareTo(b.fullName));
  return staff;
}

List<PinStaffEntry> mergeSelfPinRoster({
  required List<PinStaffEntry>? existing,
  required String userId,
  required String userName,
  required DateTime now,
}) {
  final nowIso = now.toUtc().toIso8601String();
  final entry = PinStaffEntry(
    id: userId,
    fullName: userName,
    lastUsedAt: nowIso,
  );
  final roster = [...?existing];
  final index = roster.indexWhere((e) => e.id == userId);
  if (index >= 0) {
    roster[index] = entry;
  } else {
    roster.add(entry);
  }
  roster.sort((a, b) => a.fullName.compareTo(b.fullName));
  return applyMergeSelfCap(roster, protectUserId: userId);
}

List<PinStaffEntry> applyMergeSelfCap(
  List<PinStaffEntry> roster, {
  required String protectUserId,
  int cap = pinDeviceMergeSelfCap,
}) {
  if (roster.length <= cap) return roster;

  final toEvictCount = roster.length - cap;
  final candidates = roster.where((e) => e.id != protectUserId).toList()
    ..sort(_compareLastUsedOldestFirst);

  final idsToRemove =
      candidates.take(toEvictCount).map((e) => e.id).toSet();

  return roster
      .where((e) => !idsToRemove.contains(e.id))
      .toList()
    ..sort((a, b) => a.fullName.compareTo(b.fullName));
}

int _compareLastUsedOldestFirst(PinStaffEntry a, PinStaffEntry b) {
  final aTime = a.lastUsedAt;
  final bTime = b.lastUsedAt;
  if (aTime == null && bTime == null) return a.id.compareTo(b.id);
  if (aTime == null) return -1;
  if (bTime == null) return 1;
  final byTime = aTime.compareTo(bTime);
  if (byTime != 0) return byTime;
  return a.id.compareTo(b.id);
}
