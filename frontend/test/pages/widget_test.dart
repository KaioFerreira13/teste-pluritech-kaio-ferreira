import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pluritech_frontend/pages/stays_page.dart';
import 'package:pluritech_frontend/services/stay_service.dart';

void main() {
  testWidgets('exibe mensagem quando nao existem hospedagens', (
    tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(
        '[]',
        200,
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: StaysPage(
          service: StayService(client: mockClient),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hotel para Pets'), findsOneWidget);
    expect(
      find.text('Nenhuma hospedagem cadastrada.'),
      findsOneWidget,
    );
  });
}