import 'package:flutter/material.dart';
import '../../data/model/network_response.dart';
import '../../data/model/task_list_wrapper_model.dart';
import '../../data/model/task_model.dart';
import '../../data/network_caller.dart/network_caller.dart';
import '../../utils/api_url.dart';
import '../../utils/app_colors.dart';
import '../widgets/center_progress_indicator.dart';
import '../widgets/custom_toast.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/task_list_item.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _completeTaskInProgress = false;
  List<TaskModel> completeTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompleteTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        color: AppColor.themeColor,
        onRefresh: () async {
          _getCompleteTask();
        },
        child: Visibility(
          visible: _completeTaskInProgress == false,
          replacement: const CenterProgressIndicator(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              child: ListView.builder(
                itemCount: completeTaskList.length,
                itemBuilder: (context, index) {
                  return TaskListItem(
                    taskModel: completeTaskList[index],
                    labelBgColor: AppColor.completeLabelColor,
                    onUpdateTask: () {
                      _getCompleteTask();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCompleteTask() async {
    _completeTaskInProgress = true;

    if (mounted) {
      setState(() {});
    }

    NetworkResponse response =
        await NetworkCaller.getResponse(ApiUrl.completeTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      completeTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      setCustomToast(
        response.errorMessage ?? "Get complete task failed!",
        Icons.error_outline,
        AppColor.red,
        AppColor.white,
      );
    }

    _completeTaskInProgress = false;

    if (mounted) {
      setState(() {});
    }
  }
}
