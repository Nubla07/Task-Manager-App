import 'package:flutter/material.dart';
import '../../data/model/network_response.dart';
import '../../data/network_caller.dart/network_caller.dart';
import '../../utils/api_url.dart';
import '../../utils/app_colors.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_toast.dart';
import '../widgets/elevated_icon_button.dart';
import '../widgets/loading_dialog.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTextEditingController = TextEditingController();
  final TextEditingController _descriptionTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 27,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _subjectTextEditingController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: "Subject",
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter subject";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _descriptionTextEditingController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Description",
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter description";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedIconButton(
                    icon: Icons.arrow_circle_right_outlined,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addNewTask();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {

    _addNewTaskInProgress = true;

    if (mounted) {
      setState(() {});
    }

    loadingDialog(context);

    Map<String, dynamic> requestData = {
      "title": _subjectTextEditingController.text.trim(),
      "description": _descriptionTextEditingController.text.trim(),
      "status": "New",
    };

    NetworkResponse response =
        await NetworkCaller.postResponse(ApiUrl.createTask, body: requestData);

    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.isSuccess) {
      _clearTextField();
      if (mounted) {
        setCustomToast(
          "New task added!",
          Icons.done,
          AppColor.themeColor,
          AppColor.white,
        ).show(context);
        Navigator.pop(context);
      }
    } else {
      _clearTextField();
      if (mounted) {
        setCustomToast(
          "New task add failed!",
          Icons.error_outline,
          AppColor.red,
          AppColor.white,
        ).show(context);
      }
    }
  }

  void _clearTextField() {
    _subjectTextEditingController.clear();
    _descriptionTextEditingController.clear();
  }

  @override
  void dispose() {
    _subjectTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    super.dispose();
  }
}