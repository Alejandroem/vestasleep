import 'package:flutter_test/flutter_test.dart';
import 'package:vestasleep/constants.dart';

void main() {
  test("Constant for mocked health data should be false", () {
    expect(USE_MOCK_HEALTH_DATA, false);
  });
}
