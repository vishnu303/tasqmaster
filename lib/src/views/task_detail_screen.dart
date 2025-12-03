import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasqmaster/src/models/task.dart';
import 'package:tasqmaster/src/viewmodels/task_detail_view_model.dart';
import 'package:tasqmaster/src/viewmodels/task_list_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.yellow.shade700;
      case TaskStatus.inprogress:
        return Colors.blue.shade700;
      case TaskStatus.completed:
        return Colors.green.shade700;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade300;
      case TaskPriority.medium:
        return Colors.orange.shade300;
      case TaskPriority.low:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskListViewModel = Provider.of<TaskListViewModel>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider(
      create: (_) =>
          TaskDetailViewModel(task: task, taskListViewModel: taskListViewModel),
      child: Scaffold(
        appBar: AppBar(title: const Text('Task Details'), elevation: 0),
        body: Consumer<TaskDetailViewModel>(
          builder: (context, viewModel, child) {
            final currentTask = viewModel.task;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          currentTask.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Chip(
                        label: Text(
                          currentTask.status.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: _getStatusColor(currentTask.status),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildDetailRow(
                    context,
                    icon: Icons.tag,
                    label: 'Task ID',
                    value: currentTask.id,
                  ),
                  const SizedBox(height: 16),

                  _buildDetailSection(
                    context,
                    icon: Icons.description,
                    label: 'Description',
                    child: Text(
                      currentTask.description.isEmpty
                          ? 'No description provided'
                          : currentTask.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    context,
                    icon: Icons.flag,
                    label: 'Priority',
                    value: currentTask.priority.displayName,
                    valueColor: _getPriorityColor(currentTask.priority),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    context,
                    icon: Icons.info,
                    label: 'Status',
                    value: currentTask.status.displayName,
                    valueColor: _getStatusColor(currentTask.status),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Created Time',
                    value: viewModel.formattedCreatedTime,
                  ),
                  const SizedBox(height: 24),

                  _buildDetailSection(
                    context,
                    icon: Icons.checklist,
                    label: 'Checklist',
                    child: _buildChecklist(context, currentTask.checklist),
                  ),
                  const SizedBox(height: 32),

                  if (currentTask.status != TaskStatus.completed)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await viewModel.markCompleted();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task marked as completed'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Completed'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uploading...')),
                        );
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Image'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade400),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.only(left: 32), child: child),
      ],
    );
  }

  Widget _buildChecklist(BuildContext context, List<String> checklist) {
    if (checklist.isEmpty) {
      return Text(
        'No checklist items',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      children: checklist.map((item) {
        return ListTile(
          leading: Icon(Icons.circle, size: 10, color: Colors.grey.shade500),
          title: Text(
            item,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade300),
          ),
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}
