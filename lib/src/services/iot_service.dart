import 'package:tasqmaster/src/models/task.dart';

class IoTService {
  Future<Task?> simulateIoTPayload() async {
    final Map<String, dynamic> iotPayload = {
      'device_id': 'AQI_V2-001',
      'tvoc': 0.89,
      'ammonia': 14,
      'status': 'high',
    };

    if (iotPayload['status'] == 'high') {
      return Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'IoT Alert: Deep Cleaning Required',
        description:
            'High TVOC (${iotPayload['tvoc']}) and Ammonia (${iotPayload['ammonia']}) levels detected from device ${iotPayload['device_id']}. Deep cleaning required.',
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
        checklist: [
          'Ventilate the area',
          'Check air quality sensors',
          'Schedule deep cleaning',
          'Notify maintenance team',
        ],
      );
    }

    return null;
  }
}
