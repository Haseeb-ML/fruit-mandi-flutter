import 'package:flutter/material.dart';
import '../models/mandi_models.dart';

class NotificationsScreen extends StatelessWidget {
  final List<MandiNotification> notifications;
  final VoidCallback onMarkAllRead;
  final ValueChanged<String> onMarkOneRead;

  const NotificationsScreen({
    super.key,
    required this.notifications,
    required this.onMarkAllRead,
    required this.onMarkOneRead,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => n.unread).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  '$unreadCount unread — اطلاعات',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            if (unreadCount > 0)
              TextButton(
                onPressed: onMarkAllRead,
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Color(0xFF0E7C3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...notifications.map((n) {
          Color bg;
          Color border;
          Color iconColor;
          IconData icon;

          switch (n.variant) {
            case 'warning':
              bg = const Color(0xFFFFFBEB);
              border = const Color(0xFFFDE68A);
              iconColor = const Color(0xFFD97706);
              icon = Icons.warning_amber_rounded;
              break;
            case 'danger':
              bg = const Color(0xFFFEF2F2);
              border = const Color(0xFFFECACA);
              iconColor = const Color(0xFFDC2626);
              icon = Icons.block_rounded;
              break;
            case 'success':
              bg = const Color(0xFFF0FDF4);
              border = const Color(0xFFBBF7D0);
              iconColor = const Color(0xFF16A34A);
              icon = Icons.check_circle_outline_rounded;
              break;
            default:
              bg = const Color(0xFFEFF6FF);
              border = const Color(0xFFBFDBFE);
              iconColor = const Color(0xFF2563EB);
              icon = Icons.info_outline_rounded;
          }

          return GestureDetector(
            onTap: () => onMarkOneRead(n.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 19, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              n.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                            ),
                            if (n.unread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: iconColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          n.urdu,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n.message,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF4B5563),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n.time,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

