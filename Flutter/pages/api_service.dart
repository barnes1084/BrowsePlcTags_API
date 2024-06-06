import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseTagsUrl = "https://localhost:7183/Tags";
  final String baseIniFilesUrl = "https://localhost:7183/IniFiles";

  Future<List<dynamic>> fetchPlcTags(String ipAddress, String slot) async {
    try {
      final response = await http.get(
        Uri.parse('$baseTagsUrl/GetTags?ipAddress=$ipAddress&slot=$slot'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load PLC tags');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<List<dynamic>> fetchStoredPlcTags(String ipAddress, String slot) async {
    try {
      final response = await http.get(
        Uri.parse('$baseTagsUrl/GetStoredTags?ipAddress=$ipAddress&slot=$slot'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load PLC tags');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<List<dynamic>> fetchIniFileNames(String directoryPath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseIniFilesUrl/filenames?directoryPath=$directoryPath'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load ini file names');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<Map<String, dynamic>> fetchIniFileContents(String filePath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseIniFilesUrl/contents?filePath=$filePath'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load ini file contents');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<String> updateIniFile(String filePath, Map<String, dynamic> contents) async {
    final response = await http.post(
      Uri.parse('$baseIniFilesUrl/update?filePath=$filePath'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(contents),
    );

    if (response.statusCode == 200) {
      return "File updated successfully";
    } else {
      throw Exception('Failed to update ini file: Status code ${response.statusCode}');
    }
  }


  Future<String> createIniFile(String filePath, Map<String, dynamic> contents) async {
    try {
      final response = await http.post(
        Uri.parse('$baseIniFilesUrl/create?filePath=$filePath'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(contents),
      );

      if (response.statusCode == 200) {
        return "File created successfully";
      } else {
        return "Failed to create ini file";
      }
    } catch (e) {
      throw Exception('Failed to create ini file: $e');
    }
  }
}