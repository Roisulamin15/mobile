import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

// Fungsi yang akan dites
Future<bool> registerUser(
    http.Client client, String username, String email, String password) async {
  final response = await client.post(
    Uri.parse('http://10.0.2.2:3000/api/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': username,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['success'];
  }
  return false;
}

void main() {
  group('Register User', () {
    test('Register berhasil dengan data valid', () async {
      // Mock client dengan respons berhasil
      final mockClient = MockClient((request) async {
        return http.Response(
            json.encode({'success': true, 'message': 'Registrasi berhasil'}),
            200);
      });

      // Panggil fungsi register
      final result = await registerUser(
          mockClient, 'testuser', 'testuser@example.com', 'password123');

      // Periksa hasilnya
      expect(result, isTrue);
    });

    test('Register gagal karena server error', () async {
      // Mock client dengan respons error
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      // Panggil fungsi register
      final result = await registerUser(
          mockClient, 'testuser', 'testuser@example.com', 'password123');

      // Periksa hasilnya
      expect(result, isFalse);
    });

    test('Register gagal karena email sudah digunakan', () async {
      // Mock client dengan respons email sudah digunakan
      final mockClient = MockClient((request) async {
        return http.Response(
            json.encode({'success': false, 'message': 'Email already exists'}),
            200);
      });

      // Panggil fungsi register
      final result = await registerUser(
          mockClient, 'testuser', 'existingemail@example.com', 'password123');

      // Periksa hasilnya
      expect(result, isFalse);
    });
  });
}
