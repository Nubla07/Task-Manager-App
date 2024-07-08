import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/asset_paths.dart';

class CustomCircleAvatar extends StatefulWidget {
  const CustomCircleAvatar({
    super.key,
    required this.imageString,
    this.imageWidth,
    this.imageHeight,
    this.imageRadius,
  });

  final String imageString;
  final double? imageWidth;
  final double? imageHeight;
  final double? imageRadius;

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  Uint8List? imageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      final bytes = base64Decode(widget.imageString);
      setState(() {
        imageBytes = bytes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: const AssetImage(AssetPaths.errorPicture),
      radius: widget.imageRadius,
      child: isLoading
          ? const CircularProgressIndicator(
              color: AppColor.themeColor,
            )
          : ClipOval(
              child: Image.memory(
                imageBytes!,
                fit: BoxFit.cover,
                width: widget.imageWidth,
                height: widget.imageHeight,
                errorBuilder: (_, __, ___) {
                  return CircleAvatar(
                    radius: widget.imageRadius,
                    backgroundImage: const AssetImage(AssetPaths.profilePicture),
                  );
                },
              ),
            ),
    );
  }
}