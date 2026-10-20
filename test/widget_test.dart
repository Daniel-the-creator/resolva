import 'package:flutter_test/flutter_test.dart';
import 'package:resolva/main.dart';

void main() {
  testWidgets('Resolva smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ResolvaApp());

    // Verify brand text is found
    expect(find.text('RESOLVA'), findsWidgets);
  });
}
