import 'package:flutter/foundation.dart';
import 'package:tasqmaster/core/exceptions/network_exception.dart';
import 'package:tasqmaster/src/models/task.dart';
import 'package:tasqmaster/src/services/iot_service.dart';
import 'package:tasqmaster/src/services/task_api_service.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskApiService _apiService;
  final IoTService _iotService;

  TaskListViewModel({TaskApiService? apiService, IoTService? iotService})
    : _apiService = apiService ?? TaskApiService(),
      _iotService = iotService ?? IoTService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isIoTLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isIoTLoading => _isIoTLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _apiService.getTasks();
      _errorMessage = null;
    } catch (e) {
      if (e is NetworkException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final createdTask = await _apiService.createTask(task);
      _tasks = [createdTask, ..._tasks];
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      if (e is NetworkException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
      rethrow;
    }
  }

  Future<void> simulateIoT() async {
    _isIoTLoading = true;
    notifyListeners();

    try {
      final task = await _iotService.simulateIoTPayload();
      if (task != null) {
        await createTask(task);
      }
    } catch (e) {
      if (e is NetworkException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
    } finally {
      _isIoTLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _apiService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      if (e is NetworkException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
      rethrow;
    }
  }
}
