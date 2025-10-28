import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/summary_models.dart';

abstract class HomeRemoteDataSource {
  Future<SummaryModel> fetchSummary({
    required int userId,
    DateTime? date,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final String baseUrl;       // ex: http://10.0.2.2:5000
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.baseUrl, http.Client? httpClient})
      : client = httpClient ?? http.Client();

  @override
  Future<SummaryModel> fetchSummary({required int userId, DateTime? date}) async {
    final dateStr = (date ?? DateTime.now()).toIso8601String().split('T').first;
    final uri = Uri.parse('$baseUrl/users/$userId/summary').replace(queryParameters: {'date': dateStr});

    final res = await client.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch summary (${res.statusCode}): ${res.body}');
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    return SummaryModel.fromJson(map);
  }
}
