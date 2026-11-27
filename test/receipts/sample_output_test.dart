// Test runs leave the committed samples alone.
import 'package:flutter_test/flutter_test.dart';

import '../helpers/sample_output.dart';

void main() {
  test('samples go to build/test_samples by default', () {
    expect(
      sampleOutputDir('receipt_samples', environment: const {}).path,
      'build/test_samples/receipt_samples',
    );
    expect(
      sampleOutputDir('receipt_samples', environment: const {'UPDATE_SAMPLES': '0'}).path,
      'build/test_samples/receipt_samples',
    );
  });

  test('UPDATE_SAMPLES=1 refreshes the committed samples', () {
    expect(
      sampleOutputDir('receipt_samples', environment: const {'UPDATE_SAMPLES': '1'}).path,
      'docs/receipt_samples',
    );
  });
}
