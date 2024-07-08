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

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _cancelledTaskInProgress = false;
  List<TaskModel> cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _cancelledTaskInProgress
          ? const CenterProgressIndicator()
          : RefreshIndicator(
              color: AppColor.themeColor,
              onRefresh: () async {
                _getCancelledTask();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: cancelledTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskListItem(
                        taskModel: cancelledTaskList[index],
                        labelBgColor: AppColor.cancelledLabelColor,
                        onUpdateTask: () {
                          _getCancelledTask();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _getCancelledTask() async {
    setState(() {
      _cancelledTaskInProgress = true;
    });

    NetworkResponse response = await NetworkCaller.getResponse(ApiUrl.canceledTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      cancelledTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      setCustomToast(
        response.errorMessage ?? "Get cancelled task failed!",
        Icons.error_outline,
        AppColor.red,
        AppColor.white,
      );
    }

    _cancelledTaskInProgress = false;

    if (mounted) {
      setState(() {});
    }
  }
}