// Displays a single chat list tile showing the other participant's initial,
// name, last message preview, and timestamp. Navigates to the chat screen
// on tap, generating the chat ID from both user UIDs.

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String otherUid;
  final String otherName;
  final String lastMessage;
  final String time;
  final String currentUid;
  final bool isDark;

  const ChatTile({
    super.key,
    required this.otherUid,
    required this.otherName,
    required this.lastMessage,
    required this.time,
    required this.currentUid,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final initial = otherName.isNotEmpty ? otherName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isDark
              ? AppColors.darkPrimary.withValues(alpha: 0.2)
              : AppColors.lightPrimary.withValues(alpha: 0.1),
          child: Text(
            initial,
            style: TextStyle(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          otherName,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {
          final chatID = generateChatID(otherUid, currentUid);
          Navigator.pushNamed(
            context,
            AppRoutes.chat,
            arguments: {
              'chatID': chatID,
              'otherUid': otherUid,
              'otherName': otherName,
            },
          );
        },
      ),
      ),
    );
  }
}
