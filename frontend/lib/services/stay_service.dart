import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stay.dart';

class StayService {
  StayService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  String _formatApiDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  Future<List<Stay>> getStays() async {
    final response = await _client.get(Uri.parse('$apiUrl/stays'));

    if (response.statusCode != 200) {
      throw Exception('Não foi possível carregar as hospedagens');
    }

    final jsonList =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return jsonList
        .map((json) => Stay.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createStay({
    required String tutorName,
    required String tutorContact,
    required String species,
    required String breed,
    required DateTime entryDate,
    DateTime? expectedExitDate,
  }) async {
    final response = await _client.post(
      Uri.parse('$apiUrl/stays'),
      headers: {'content-type': 'application/json; charset=utf-8'},
      body: jsonEncode({
        'tutorName': tutorName,
        'tutorContact': tutorContact,
        'species': species,
        'breed': breed,
        'entryDate': _formatApiDate(entryDate),
        'expectedExitDate': expectedExitDate == null
            ? null
            : _formatApiDate(expectedExitDate),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Não foi possível cadastrar a hospedagem! Tente novamente',
      );
    }
  }
}
