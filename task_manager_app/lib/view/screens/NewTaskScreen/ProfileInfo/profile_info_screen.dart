import 'package:flutter/material.dart';
import '../../../../utils/app_route.dart';
import '../../../Controller/auth_controller.dart';
import '../../../widgets/background_widget.dart';
import '../../../widgets/custom_circle_avatar.dart';
import 'inner/details_view_widget.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Info'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.updateProfileScreen);
            },
            icon: const Padding(
              padding: EdgeInsets.only(
                right: 15,
              ),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CustomCircleAvatar(
                      imageString: AuthController.userData?.photo ?? '',
                      imageWidth: 100,
                      imageHeight: 100,
                      imageRadius: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AuthController.userData?.fullName ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 15),
                  detailsViewWidget(
                    header: 'Email:',
                    info: AuthController.userData?.email ?? '',
                  ),
                  const SizedBox(height: 7),
                  detailsViewWidget(
                    header: 'Number:',
                    info: AuthController.userData?.mobile ?? '',
                  ),
                  const SizedBox(height: 7),
                  const detailsViewWidget(
                    header: 'Password:',
                    info: '**********',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
