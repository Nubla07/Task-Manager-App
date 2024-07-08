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

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _progressTaskInProgress = false;
  List<TaskModel> progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _progressTaskInProgress
          ? const CenterProgressIndicator()
          : RefreshIndicator(
              color: AppColor.themeColor,
              onRefresh: () async {
                _getProgressTask();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: progressTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskListItem(
                        taskModel: progressTaskList[index],
                        labelBgColor: AppColor.progressLabelColor,
                        onUpdateTask: () {
                          _getProgressTask();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _getProgressTask() async {
    setState(() {
      _progressTaskInProgress = true;
    });

    NetworkResponse response =
        await NetworkCaller.getResponse(ApiUrl.progressTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      progressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      setCustomToast(
        response.errorMessage ?? "Get progress task failed!",
        Icons.error_outline,
        AppColor.red,
        AppColor.white,
      );
    }

    setState(() {
      _progressTaskInProgress = false;
    });
  }
}
