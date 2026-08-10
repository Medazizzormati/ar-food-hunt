import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'notifications_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _nearbyTrucks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    final double dLat = (lat2 - lat1) * (math.pi / 180);
    final double dLon = (lon2 - lon1) * (math.pi / 180);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) * math.cos(lat2 * (math.pi / 180)) * 
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m away';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km away';
    }
  }

  Future<void> _loadData() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      position = Position(
        latitude: 40.7128,
        longitude: -74.0060,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    try {
      final res = await ApiService.getFoodTrucks();
      if (res.statusCode == 200) {
        final trucks = jsonDecode(res.body) as List;
        final formattedTrucks = trucks.map((t) {
          final lat = (t['latitude'] ?? 0.0).toDouble();
          final lon = (t['longitude'] ?? 0.0).toDouble();
          final distance = _calculateDistance(position!.latitude, position.longitude, lat, lon);
          
          return {
            'name': t['name'] ?? 'Food Truck',
            'distanceVal': distance,
            'distance': _formatDistance(distance),
            'emoji': '🍔',
            'isEvent': (t['status'] ?? '') == 'Active Event'
          };
        }).toList();

        formattedTrucks.sort((a, b) => (a['distanceVal'] as double).compareTo(b['distanceVal'] as double));
        _nearbyTrucks = formattedTrucks.take(2).toList();
      }
    } catch (e) {
      //
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(fontSize: 14, color: textColor)),
            const Text('Explorer! 👋', style: TextStyle(color: AppTheme.primary)),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, size: 28),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard(context, '850', 'XP', Icons.star_rounded, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, '1,250', 'Coins', Icons.monetization_on_rounded, Colors.purple)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, '24', 'Items', Icons.inventory_2_rounded, Colors.teal)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Event Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.secondary, AppTheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppTheme.secondary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                    child: const Text('🔴 LIVE EVENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  const Text('🍔 Summer Burger Week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('Double XP at all Burger Trucks!', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Join Event'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text('Daily Missions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Missions List
            _buildMissionCard(context, 'Visit 3 Food Trucks', '2/3', 0.66, '🍔'),
            _buildMissionCard(context, 'Collect 5 Burgers', '1/5', 0.2, '🍟'),
            
            const SizedBox(height: 24),
            const Text('Nearby Trucks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Nearby Trucks
            ..._nearbyTrucks.map((t) => _buildTruckCard(
              context, 
              t['name'] as String, 
              t['distance'] as String, 
              t['emoji'] as String, 
              t['isEvent'] as bool
            )),
            
            if (_nearbyTrucks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No food trucks found nearby.'),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.glassDecoration(context),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted)),
        ],
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, String title, String progressTxt, double progress, String emoji) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
              color: AppTheme.primary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
        trailing: Text(progressTxt, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
      ),
    );
  }

  Widget _buildTruckCard(BuildContext context, String name, String distance, String emoji, bool isEvent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(Icons.location_on, size: 14, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
            const SizedBox(width: 4),
            Text(distance, style: TextStyle(color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted, fontSize: 12)),
          ],
        ),
        trailing: isEvent 
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Text('Event', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            : null,
      ),
    );
  }
}
