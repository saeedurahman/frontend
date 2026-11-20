import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the Quick Add draft in the device's preferences, one draft per
/// business and user, so a crash, restart or power cut loses nothing.
class SharedPrefsQuickAddDraftStore implements QuickAddDraftStore {
  SharedPrefsQuickAddDraftStore(this._prefs, {required Future<String?> Function() scope})
      : _scope = scope;

  final SharedPreferences _prefs;

  /// "businessId:userId" (null before login: the draft is then not kept).
  final Future<String?> Function() _scope;

  Future<String?> _key() async {
    final scope = await _scope();
    return scope == null ? null : 'quick_add.draft.$scope';
  }

  @override
  Future<QuickAddDraft?> load() async {
    try {
      final key = await _key();
      if (key == null) return null;
      final text = _prefs.getString(key);
      if (text == null || text.isEmpty) return null;
      final json = jsonDecode(text);
      if (json is! Map) return null;
      final draft = QuickAddDraft.fromJson(Map<String, dynamic>.from(json));
      return draft == null || draft.rows.isEmpty ? null : draft;
    } catch (e) {
      debugPrint('[QuickAdd] draft unreadable, ignoring it: $e');
      return null;
    }
  }

  @override
  Future<void> save(QuickAddDraft draft) async {
    try {
      final key = await _key();
      if (key == null) return;
      await _prefs.setString(key, jsonEncode(draft.toJson()));
    } catch (e) {
      debugPrint('[QuickAdd] could not keep the draft: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      final key = await _key();
      if (key != null) await _prefs.remove(key);
    } catch (_) {}
  }
}

/// In memory (tests).
class MemoryQuickAddDraftStore implements QuickAddDraftStore {
  QuickAddDraft? draft;
  int saves = 0;

  @override
  Future<QuickAddDraft?> load() async => draft;

  @override
  Future<void> save(QuickAddDraft draft) async {
    saves++;
    this.draft = QuickAddDraft.fromJson(jsonDecode(jsonEncode(draft.toJson())) as Map<String, dynamic>);
  }

  @override
  Future<void> clear() async => draft = null;
}
