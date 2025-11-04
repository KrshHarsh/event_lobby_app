import 'package:dio/dio.dart';

class AroundUApi {
  final Dio _dio;

  AroundUApi(String token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.aroundu.in',
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': '*/*',
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );

  Future<Map<String, dynamic>> fetchEventDetail(String eventId) async {
    try {
      final res = await _dio.get('/match/lobby/public/$eventId/detail');
      if (res.statusCode == 200 && res.data != null) {
        return Map<String, dynamic>.from(res.data);
      }
      throw Exception('Unexpected status: ${res.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('API error: $msg');
    }
  }
}
