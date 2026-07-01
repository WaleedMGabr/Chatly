// Displays a single chat message as a styled bubble with gradient for sent
// messages and flat color for received messages. Shows the message text and
// a formatted timestamp, aligned left or right based on the sender.

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bubbleColor = isMe
        ? (isDark ? AppColors.darkBubbleMe : AppColors.lightBubbleMe)
        : (isDark ? AppColors.darkBubbleOther : AppColors.lightBubbleOther);

    final Color bubbleGradientEnd = isMe
        ? (isDark ? AppColors.darkBubbleMeEnd : AppColors.lightBubbleMeEnd)
        : bubbleColor;

    final Color textColor = isMe
        ? Colors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final Color timeColor = isMe
        ? Colors.white.withOpacity(0.7)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    String formatted = '';
    if (message.msgTime != null) {
      final t = message.msgTime!;
      formatted =
          '${t.day}-${t.month}-${t.year % 100} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.only(
          bottom: 4,
          top: 8,
          right: isMe ? 12 : 60,
          left: isMe ? 60 : 12,
        ),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
                  colors: [bubbleColor, bubbleGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : bubbleColor,
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(20),
            topLeft: const Radius.circular(20),
            bottomRight:
                isMe ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft:
                isMe ? const Radius.circular(20) : const Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: bubbleColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.msgText,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatted,
                style: TextStyle(
                  color: timeColor,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
