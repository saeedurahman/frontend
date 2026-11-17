import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helpers for regression tests of "form -> cubit" screens.
///
/// A real keyboard inserts each character at the caret of the field. The test
/// `enterText` replaces the whole text and puts the caret at the end, which
/// hides every bug where a rebuild resets the caret. [typeKey] does what a
/// keyboard does: it inserts at the field's current selection (an invalid
/// selection counts as position 0, which is where the engine puts it).

/// The text field inside [field] (the finder may point at a wrapper).
Finder editableIn(Finder field) =>
    find.descendant(of: field, matching: find.byType(EditableText)).first;

EditableTextState editableState(WidgetTester t, Finder field) =>
    t.state<EditableTextState>(editableIn(field));

/// What the field currently shows.
String shownIn(WidgetTester t, Finder field) => editableState(t, field).textEditingValue.text;

/// Lets a cubit emit (delivered on a microtask) reach the widgets: one frame
/// to deliver it, one to build it.
Future<void> settle(WidgetTester t) async {
  await t.pump();
  await t.pump();
}

/// Clicks into the field so that it has focus and a keyboard connection.
Future<void> focusField(WidgetTester t, Finder field) async {
  await t.ensureVisible(field);
  await t.pump();
  await t.tap(editableIn(field));
  await t.pump();
}

/// Types one character at the caret, like a keyboard.
Future<void> typeKey(WidgetTester t, Finder field, String ch) async {
  final v = editableState(t, field).textEditingValue;
  final sel = v.selection.isValid ? v.selection : const TextSelection.collapsed(offset: 0);
  final text = v.text.replaceRange(sel.start, sel.end, ch);
  t.testTextInput.updateEditingValue(
    TextEditingValue(text: text, selection: TextSelection.collapsed(offset: sel.start + ch.length)),
  );
  await settle(t);
}

/// Presses backspace once at the caret.
Future<void> backspace(WidgetTester t, Finder field) async {
  final v = editableState(t, field).textEditingValue;
  final sel = v.selection.isValid ? v.selection : const TextSelection.collapsed(offset: 0);
  if (sel.isCollapsed && sel.start == 0) return;
  final start = sel.isCollapsed ? sel.start - 1 : sel.start;
  final text = v.text.replaceRange(start, sel.end, '');
  t.testTextInput.updateEditingValue(
    TextEditingValue(text: text, selection: TextSelection.collapsed(offset: start)),
  );
  await settle(t);
}

/// Focuses [field] and types [text] one character at a time. After every
/// keystroke the field must show exactly what has been typed so far, and
/// [afterEach] (usually an assertion about the cubit state) runs.
Future<void> typeCharByChar(
  WidgetTester t,
  Finder field,
  String text, {
  void Function(int index, String typedSoFar)? afterEach,
  bool focus = true,
}) async {
  if (focus) await focusField(t, field);
  for (var i = 0; i < text.length; i++) {
    await typeKey(t, field, text[i]);
    final typed = text.substring(0, i + 1);
    expect(shownIn(t, field), typed, reason: 'after typing "${text[i]}" (key ${i + 1} of "$text")');
    afterEach?.call(i, typed);
  }
}

/// Pumps [child] in a bare app with [cubit] provided (a real one, not a mock),
/// on a desktop-sized window.
Future<void> pumpFormWithCubit<C extends StateStreamableSource<Object?>>(
  WidgetTester t, {
  required C cubit,
  required Widget child,
  Size size = const Size(1400, 2400),
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    MaterialApp(
      home: BlocProvider<C>.value(
        value: cubit,
        child: Scaffold(body: child),
      ),
    ),
  );
  await t.pump();
}

/// The test font (Ahem) is far wider than the real one, so rows report
/// cosmetic overflows; any other framework error still fails the test.
void ignoreOverflowErrors() {
  final prev = FlutterError.onError;
  FlutterError.onError = (d) {
    if (d.exceptionAsString().contains('overflowed')) return;
    prev?.call(d);
  };
  addTearDown(() => FlutterError.onError = prev);
}
