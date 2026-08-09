import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pluritech_frontend/services/stay_service.dart';

void main() {
  test('carrega hospedagens da API', () async {
    final mockClient = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/stays');

      return http.Response(
        jsonEncode([
          {
            'id': 'uuid-1',
            'code': 'DOG-1',
            'tutorName': 'Maria',
            'tutorContact': '11999999999',
            'species': 'dog',
            'breed': 'SRD',
            'entryDate': '2026-08-08',
            'expectedExitDate': '2026-08-12',
            'currentDays': 1,
            'expectedTotalDays': 4,
            'createdAt': '2026-08-08T12:00:00.000Z',
            'updatedAt': '2026-08-08T12:00:00.000Z',
          },
        ]),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final service = StayService(client: mockClient);

    final stays = await service.getStays();

    expect(stays, hasLength(1));
    expect(stays.first.code, 'DOG-1');
    expect(stays.first.tutorName, 'Maria');
    expect(stays.first.currentDays, 1);
  });

  test('lança exceção quando a API retorna erro', () async {
    final mockClient = MockClient((request) async {
      return http.Response('', 500);
    });
    final service = StayService(client: mockClient);

    await expectLater(service.getStays(), throwsA(isA<Exception>()));
  });

  test('envia os dados para cadastrar uma hospedagem', () async {
    final mockClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/stays');
      expect(request.headers['content-type'], contains('application/json'));

      final body = jsonDecode(request.body) as Map<String, dynamic>;

      expect(body, {
        'tutorName': 'Maria',
        'tutorContact': '11999999999',
        'species': 'dog',
        'breed': 'SRD',
        'entryDate': '2026-08-09',
        'expectedExitDate': '2026-08-12',
      });

      return http.Response('', 201);
    });

    final service = StayService(client: mockClient);

    await service.createStay(
      tutorName: 'Maria',
      tutorContact: '11999999999',
      species: 'dog',
      breed: 'SRD',
      entryDate: DateTime(2026, 8, 9),
      expectedExitDate: DateTime(2026, 8, 12),
    );
  });

  test('lanca excecao quando o cadastro e rejeitado', () async {
    final mockClient = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;

      expect(body['tutorContact'], ' ');

      return http.Response('', 400);
    });

    final service = StayService(client: mockClient);

    await expectLater(
      service.createStay(
        tutorName: 'Maria',
        tutorContact: ' ',
        species: 'dog',
        breed: 'SRD',
        entryDate: DateTime(2026, 8, 9),
        expectedExitDate: DateTime(2026, 8, 12),
      ),
      throwsA(isA<Exception>()),
    );
  });
}
