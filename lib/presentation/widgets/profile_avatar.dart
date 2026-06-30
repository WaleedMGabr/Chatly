import 'dart:convert';

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final UserEntity? user;
  final String? pendingPhotoBase64;
  final bool isDark;
  final bool isUpdating;
  final VoidCallback? onPickPhoto;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.pendingPhotoBase64,
    required this.isDark,
    required this.isUpdating,
    this.onPickPhoto,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;

    final base64ToUse = pendingPhotoBase64 ?? user?.photoBase64;

    if (base64ToUse != null && base64ToUse.isNotEmpty) {
      try {
        final bytes = base64Decode(base64ToUse);
        avatarContent = CircleAvatar(
          radius: 56,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {
        avatarContent = _initialsAvatar();
      }
    } else {
      avatarContent = _initialsAvatar();
    }

    return Stack(
      children: [
        avatarContent,
        if (isUpdating)
          Positioned.fill(
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.black45,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isUpdating ? null : onPickPhoto,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  width: 3,
                ),
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _initialsAvatar() {
    final initial =
        (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 56,
      backgroundColor:
          isDark ? AppColors.darkSurfaceElevated : AppColors.lightInputFill,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      ),
    );
  }
}
