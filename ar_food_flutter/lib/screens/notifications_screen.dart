import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotifCard(context, '🎯 New Mission Available!', 'Visit 5 Food Trucks today to earn 500 XP.', 'Just now', true, Icons.assignment_rounded, AppTheme.primary),
          _buildNotifCard(context, '🏆 Level Up!', 'Congratulations! You reached Level 12 Explorer.', '2 hours ago', false, Icons.star_rounded, AppTheme.secondary),
          _buildNotifCard(context, '🍔 Summer Burger Week', 'Double XP at all Burger Trucks starts now!', 'Yesterday', false, Icons.event_rounded, AppTheme.tertiary),
          _buildNotifCard(context, '🎁 Reward Unlocked', 'You earned a 20% Off Coupon for Taco Trek.', '2 days ago', false, Icons.card_giftcard_rounded, AppTheme.success),
        ],
      ),
    );
  }

  Widget _buildNotifCard(BuildContext context, String title, String body, String time, bool isUnread, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.1) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? color.withOpacity(0.3) : (isDark ? Colors.white12 : Colors.black12)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.w600, fontSize: 16))),
                    if (isUnread) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(body, style: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Text(time, style: TextStyle(color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
