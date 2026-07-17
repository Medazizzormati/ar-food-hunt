import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'name': 'Summer Burger Week',
      'type': 'Multiplier',
      'multiplier': '2x',
      'duration': '7 Days',
      'status': 'Active',
      'description': 'Double XP at all Burger Trucks! Collect burgers to earn bonus rewards.',
      'emoji': '🍔',
      'joined': false,
    },
    {
      'id': '2',
      'name': 'Taco Tuesday',
      'type': 'Special Drop',
      'multiplier': '1.5x',
      'duration': '24 Hours',
      'status': 'Upcoming',
      'description': 'Special taco collectibles available for limited time.',
      'emoji': '🌮',
      'joined': false,
    },
    {
      'id': '3',
      'name': 'Pizza Party',
      'type': 'Community Goal',
      'multiplier': '3x',
      'duration': '3 Days',
      'status': 'Ended',
      'description': 'Collect pizzas together to unlock community rewards.',
      'emoji': '🍕',
      'joined': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Events'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active Events Section
          Text(
            'Active Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._events.where((e) => e['status'] == 'Active').map((event) => _buildEventCard(event, isDark)),
          
          const SizedBox(height: 24),
          
          // Upcoming Events Section
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._events.where((e) => e['status'] == 'Upcoming').map((event) => _buildEventCard(event, isDark)),
          
          const SizedBox(height: 24),
          
          // Ended Events Section
          Text(
            'Ended Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._events.where((e) => e['status'] == 'Ended').map((event) => _buildEventCard(event, isDark)),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, bool isDark) {
    final status = event['status'] as String;
    final isJoined = event['joined'] as bool;
    
    Color statusColor;
    if (status == 'Active') {
      statusColor = AppTheme.success;
    } else if (status == 'Upcoming') {
      statusColor = AppTheme.primary;
    } else {
      statusColor = AppTheme.darkTextMuted;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: status == 'Active'
            ? LinearGradient(
                colors: [AppTheme.primary.withOpacity(0.1), AppTheme.secondary.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: status != 'Active'
            ? (isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated)
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == 'Active'
              ? AppTheme.primary.withOpacity(0.3)
              : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkBgCard : AppTheme.lightBgCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      event['emoji'],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.local_offer, size: 14, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            event['multiplier'],
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.schedule, size: 14, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                          const SizedBox(width: 4),
                          Text(
                            event['duration'],
                            style: TextStyle(
                              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event['description'],
              style: TextStyle(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (status == 'Active' || status == 'Upcoming')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      event['joined'] = !event['joined'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isJoined ? 'Left event' : 'Joined event!'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isJoined ? Colors.grey : AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isJoined ? 'Leave Event' : 'Join Event',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
