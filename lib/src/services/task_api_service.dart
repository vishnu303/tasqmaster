import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tasqmaster/core/constants/constants.dart';
import 'package:tasqmaster/core/exceptions/network_exception.dart';
import 'package:tasqmaster/src/models/task.dart';

const Duration _requestTimeout = Duration(seconds: 10);

class TaskApiService {
  final String baseUrl;
  final http.Client client;

  TaskApiService({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? _getDefaultBaseUrl(),
      client = client ?? http.Client();

  static String _getDefaultBaseUrl() {
    if (Platform.isAndroid) {
      return baseUrlAndroid;
    } else {
      return baseUrlLocal;
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((jsonItem) => Task.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException(
        'Unable to reach the server. Please ensure it is running.',
      );
    } on TimeoutException {
      throw NetworkException(
        'Request to server timed out. Check your network connection.',
      );
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            jsonDecode(response.body) as Map<String, dynamic>;
        return Task.fromJson(responseJson);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException(
        'Unable to reach the server. Please ensure it is running.',
      );
    } on TimeoutException {
      throw NetworkException(
        'Request to server timed out. Check your network connection.',
      );
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/tasks/${task.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            jsonDecode(response.body) as Map<String, dynamic>;
        return Task.fromJson(responseJson);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException(
        'Unable to reach the server. Please ensure it is running.',
      );
    } on TimeoutException {
      throw NetworkException(
        'Request to server timed out. Check your network connection.',
      );
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }
}
