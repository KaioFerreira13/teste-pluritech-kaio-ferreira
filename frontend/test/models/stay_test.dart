import 'package:flutter_test/flutter_test.dart';
import 'package:pluritech_frontend/models/stay.dart';

void main() {
  final json = {
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
  };

  test('converte JSON do backend para objeto Stay', () {
    final stay = Stay.fromJson(json);

    expect(stay.code, 'DOG-1');
    expect(stay.tutorName, 'Maria');
    expect(stay.entryDate, DateTime.parse('2026-08-08'));
    expect(stay.expectedExitDate, DateTime.parse('2026-08-12'));
    expect(stay.currentDays, 1);
    expect(stay.expectedTotalDays, 4);
  });

  test('json com datas de saida esperada e dias esperados vazios', () {
    final testJson = {
      ...json,
      'expectedExitDate': null,
      'expectedTotalDays': null,
    };

    final stay = Stay.fromJson(testJson);

    expect(stay.code, 'DOG-1');
    expect(stay.tutorName, 'Maria');
    expect(stay.entryDate, DateTime.parse('2026-08-08'));
    expect(stay.expectedExitDate, isNull);
    expect(stay.currentDays, 1);
    expect(stay.expectedTotalDays, isNull);
  });
}
