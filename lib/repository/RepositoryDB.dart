import 'dart:async';
import 'dart:io';

import '../domain/Star.dart';
import 'IRepository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepositoryDB implements IRepository {
  final String baseUrl = 'http://192.168.1.252:3000';

  RepositoryDB();

  static Future<RepositoryDB> create() async {
    return RepositoryDB();
  }

  Future<bool> isOnline() async {
    try {
      print("Checking server status");

      final response = await http
          .get(Uri.parse('$baseUrl/stars'))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("Server is online");
        return true;
      } else {
        print("Server responded with status code: ${response.statusCode}");
        return false;
      }
    } on SocketException {
      print("Server is offline (network error)");
      return false;
    } on TimeoutException {
      print("Server is offline (timeout)");
      return false;
    } catch (e) {
      print("Unexpected error: $e");
      return false;
    }
  }

  @override
  Future<List<Star>> getStars() async {
    final response = await http.get(Uri.parse('$baseUrl/stars'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((star) => Star.fromJson(star)).toList();
    } else {
      throw Exception('Failed to load stars');
    }
  }

  @override
  Future<Star> addStar(Star star) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(star.toJson()),
    );

    if (response.statusCode == 201) { // Check for 201 Created
      return Star.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add star: ${response.body}');
    }
  }

  @override
  Future<void> deleteStar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/stars/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete star');
    }
  }


  @override
  Future<Star?> getStarById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/stars/$id'));
    print("Parsing JSON: $json");

    if (response.statusCode == 200) {
      return Star.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load star');
    }
  }

  @override
  Future<Star> updateStar(Star star) {
    // TODO: implement updateStar
    throw UnimplementedError();
  }

// @override
// Future<Star> updateStar(Star star) async {
//   print("Updating star: $star");
//   final response = await http.put(
//     Uri.parse('$baseUrl/stars/${star.id}'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(star.toJson()),
//   );
//   print("Response: ${response.body}");
//
//   if (response.statusCode == 200) {
//     final updatedStar = Star.fromJson(json.decode(response.body));
//     // Update the local repository with the new ID if it has changed
//     if (updatedStar.id != star.id) {
//       await localRepository.updateStarId(star.id, updatedStar.id);
//     }
//     return updatedStar;
//   } else {
//     throw Exception('Failed to update star');
//   }
// }
}
