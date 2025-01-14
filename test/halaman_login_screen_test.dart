import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

Future<bool> loginUser(
    http.Client client, String username, String password) async {
  final response = await client.post(
    Uri.parse('http://10.0.2.2:3000/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['success'];
  }
  return false;
}

void main() {
  group('loginUser', () {
    test('Login berhasil dengan kredensial benar', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({'success': true}), 200);
      });

      final result = await loginUser(mockClient, 'user', 'password123');
      expect(result, isTrue);
    });

    test('Login gagal dengan kredensial salah', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({'success': false}), 200);
      });

      final result = await loginUser(mockClient, 'wronguser', 'wrongpassword');
      expect(result, isFalse);
    });
  });
}
