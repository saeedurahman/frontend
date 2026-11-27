// Where tests put the sample PDFs and pictures they draw.
import 'dart:io';

/// The committed samples in docs/ change only when asked for:
/// `UPDATE_SAMPLES=1 flutter test ...`. Every other run writes to
/// build/test_samples, which git ignores.
Directory sampleOutputDir(String name, {Map<String, String>? environment}) {
  final update = (environment ?? Platform.environment)['UPDATE_SAMPLES'] == '1';
  final dir = Directory(update ? 'docs/$name' : 'build/test_samples/$name');
  dir.createSync(recursive: true);
  return dir;
}
