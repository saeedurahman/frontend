// Proves the typing helper is sensitive: the old pattern (a new controller
// built from state on every rebuild) really produces "037" for "730", and the
// shared field does not.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/shared/widgets/inputs/synced_text_field.dart';

import 'form_typing.dart';

class _Cubit extends Cubit<String> {
  _Cubit() : super('');
  void set(String v) => emit(v);
}

void main() {
  Future<void> pump(WidgetTester t, _Cubit c, Widget Function(String v, _Cubit c) field) =>
      pumpFormWithCubit<_Cubit>(
        t,
        cubit: c,
        child: BlocBuilder<_Cubit, String>(builder: (_, v) => field(v, c)),
        size: const Size(600, 400),
      );

  testWidgets('control: a controller rebuilt from state in build reverses the digits', (t) async {
    final c = _Cubit();
    addTearDown(c.close);
    await pump(
      t,
      c,
      (v, c) => TextField(
        key: const Key('f'),
        controller: TextEditingController(text: v), // the bug
        onChanged: c.set,
      ),
    );
    final f = find.byKey(const Key('f'));
    await focusField(t, f);
    await typeKey(t, f, '7');
    await typeKey(t, f, '3');
    await typeKey(t, f, '0');
    expect(shownIn(t, f), isNot('730'), reason: 'the old pattern loses the caret');
    expect(shownIn(t, f), '037');
  });

  testWidgets('SyncedTextField and AppNumberField type "730" correctly', (t) async {
    final c = _Cubit();
    addTearDown(c.close);
    await pump(t, c, (v, c) => SyncedTextField(key: const Key('f'), value: v, onChanged: c.set));
    await typeCharByChar(t, find.byKey(const Key('f')), '730', afterEach: (_, typed) {
      expect(c.state, typed);
    });

    final c2 = _Cubit();
    addTearDown(c2.close);
    await pump(t, c2, (v, c) => AppNumberField(key: const Key('n'), value: v, onChanged: c.set));
    await typeCharByChar(t, find.byKey(const Key('n')), '12.50', afterEach: (_, typed) {
      expect(c2.state, typed);
    });
  });

  testWidgets('a field that is not focused follows the cubit and is normalised on blur', (t) async {
    final c = _Cubit();
    addTearDown(c.close);
    await pump(t, c, (v, c) => SyncedTextField(key: const Key('f'), value: v, onChanged: c.set));
    c.set('from cubit');
    await settle(t);
    expect(shownIn(t, find.byKey(const Key('f'))), 'from cubit');
  });
}
