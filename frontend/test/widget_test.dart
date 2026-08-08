import 'package:flutter_test/flutter_test.dart';
import 'package:pluritech_frontend/main.dart';

void main() {
  testWidgets('exibe a tela inicial', (tester) async {
    await tester.pumpWidget(const PluritechApp());

    expect(find.text('Ambiente pronto!'), findsOneWidget);
    expect(find.text('Testar novamente'), findsOneWidget);
  });
}
