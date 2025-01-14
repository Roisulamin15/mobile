// // lib/utils/token_storage.dart

// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveToken(String token) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token); // Menyimpan token
// }

// Future<String?> getToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token'); // Mengambil token
// }
