import 'dart:convert';

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/helpers.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;
  final String currentUid;
  final bool isDark;

  const UserTile({
    super.key,
    required this.user,
    required this.currentUid,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: _buildAvatar(initial),
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            user.email,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.isOnline)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppColors.online,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ],
        ),
        onTap: () {
          final chatID = generateChatID(user.uid, currentUid);
          Navigator.pushNamed(context, AppRoutes.chat, arguments: {
            'chatID': chatID,
            'otherUid': user.uid,
            'otherName': user.name,
          });
        },
      ),
      ),
    );
  }

  Widget _buildAvatar(String initial) {
    if (user.photoBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(user.photoBase64);
        return CircleAvatar(
          radius: 22,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {}
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkPrimary, AppColors.darkPrimaryVariant]
              : [AppColors.lightPrimary, AppColors.lightBubbleMeEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
