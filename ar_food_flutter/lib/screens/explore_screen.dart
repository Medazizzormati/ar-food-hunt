import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  List<ExploreItem> _exploreItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTop = _scrollController.offset > 200;
      });
    });
    _loadExploreItems();
  }

  Future<void> _loadExploreItems() async {
    // Get current position
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Default position if location not available
      position = const Position(
        latitude: 40.7128,
        longitude: -74.0060,
        timestamp: null,
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    // Mock data - in real app, fetch from API
    final mockFoodTrucks = [
      {'id': 1, 'name': 'Burger Bliss', 'emoji': '🍔', 'lat': 40.7130, 'lon': -74.0065, 'type': 'food_truck', 'status': 'Active Event', 'statusColor': Colors.orange},
      {'id': 2, 'name': 'Pizza Planet', 'emoji': '🍕', 'lat': 40.7140, 'lon': -74.0070, 'type': 'food_truck', 'status': 'Open', 'statusColor': Colors.green},
      {'id': 3, 'name': 'Ice Cream Van', 'emoji': '🍦', 'lat': 40.7150, 'lon': -74.0080, 'type': 'food_truck', 'status': 'Special Drops', 'statusColor': Colors.teal},
      {'id': 4, 'name': 'Taco Trek', 'emoji': '🌮', 'lat': 40.7160, 'lon': -74.0090, 'type': 'food_truck', 'status': 'Open', 'statusColor': Colors.purple},
      {'id': 5, 'name': 'Donut Delight', 'emoji': '🍩', 'lat': 40.7170, 'lon': -74.0100, 'type': 'food_truck', 'status': 'Special Drops', 'statusColor': Colors.pink},
      {'id': 6, 'name': 'BBQ Brothers', 'emoji': '🍖', 'lat': 40.7180, 'lon': -74.0110, 'type': 'food_truck', 'status': 'Active Event', 'statusColor': Colors.red},
      {'id': 7, 'name': 'Smoothie Station', 'emoji': '🥤', 'lat': 40.7190, 'lon': -74.0120, 'type': 'food_truck', 'status': 'Open', 'statusColor': Colors.blue},
    ];

    final mockCollectibles = [
      {'id': 101, 'name': 'Golden Burger', 'emoji': '🏆', 'lat': 40.7135, 'lon': -74.0075, 'type': 'collectible', 'status': 'Rare', 'statusColor': Colors.amber},
      {'id': 102, 'name': 'Pizza Slice', 'emoji': '🍕', 'lat': 40.7145, 'lon': -74.0085, 'type': 'collectible', 'status': 'Common', 'statusColor': Colors.grey},
      {'id': 103, 'name': 'Ice Cream Cone', 'emoji': '🍦', 'lat': 40.7155, 'lon': -74.0095, 'type': 'collectible', 'status': 'Legendary', 'statusColor': Colors.purple},
      {'id': 104, 'name': 'Taco Shell', 'emoji': '🌮', 'lat': 40.7165, 'lon': -74.0105, 'type': 'collectible', 'status': 'Common', 'statusColor': Colors.grey},
    ];

    // Combine and calculate distances
    final allItems = [...mockFoodTrucks, ...mockCollectibles];
    
    _exploreItems = allItems.map((item) {
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        item['lat'] as double,
        item['lon'] as double,
      );
      return ExploreItem(
        id: item['id'] as int,
        name: item['name'] as String,
        emoji: item['emoji'] as String,
        distance: distance,
        type: item['type'] as String,
        status: item['status'] as String,
        statusColor: item['statusColor'] as Color,
      );
    }).toList();

    // Sort by distance
    _exploreItems.sort((a, b) => a.distance.compareTo(b.distance));

    setState(() {
      _isLoading = false;
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    
    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.cos() * lat2.cos() * 
        (dLon / 2).sin() * (dLon / 2).sin();
    
    final double c = 2 * (a.sqrt()).asin();
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fake Map Background
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),
          
          // Map Pins (Mock - using first few items)
          if (!_isLoading && _exploreItems.isNotEmpty)
            ..._exploreItems.take(4).map((item) => Positioned(
              top: 200 + (item.id % 4) * 50,
              left: 80 + (item.id % 4) * 80,
              child: AnimatedFoodTruckMarker(
                assetPath: 'assets/images/${item.type == 'food_truck' ? 'burger_truck' : 'collectible'}.png',
                emoji: item.emoji,
                name: item.name,
                isEvent: item.status.contains('Event'),
              ),
            )),
          
          // Bottom Sheet with List
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBgCard.withOpacity(0.95) : AppTheme.lightBgCard.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40, 
                      height: 4, 
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white30 : Colors.black26,
                        borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _exploreItems.length,
                          itemBuilder: (context, index) {
                            final item = _exploreItems[index];
                            return _buildListTruck(
                              context,
                              item.name,
                              _formatDistance(item.distance),
                              item.emoji,
                              item.status,
                              item.statusColor,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          
          // Scroll to Top Button
          if (_showScrollToTop)
            Positioned(
              right: 16,
              bottom: 100,
              child: FloatingActionButton(
                mini: true,
                onPressed: _scrollToTop,
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildListTruck(BuildContext context, String name, String distance, String emoji, String status, Color statusColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Emoji Box
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBgCard : AppTheme.lightBgCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 16),
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                      const SizedBox(width: 4),
                      Text(
                        distance, 
                        style: TextStyle(
                          color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted, 
                          fontSize: 13
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Text(
                status, 
                style: TextStyle(
                  color: statusColor, 
                  fontSize: 12, 
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreItem {
  final int id;
  final String name;
  final String emoji;
  final double distance;
  final String type;
  final String status;
  final Color statusColor;

  ExploreItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.distance,
    required this.type,
    required this.status,
    required this.statusColor,
  });
}

class AnimatedFoodTruckMarker extends StatefulWidget {
  final String assetPath;
  final String emoji;
  final String name;
  final bool isEvent;

  const AnimatedFoodTruckMarker({
    super.key,
    required this.assetPath,
    required this.emoji,
    required this.name,
    this.isEvent = false,
  });

  @override
  State<AnimatedFoodTruckMarker> createState() => _AnimatedFoodTruckMarkerState();
}

class _AnimatedFoodTruckMarkerState extends State<AnimatedFoodTruckMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnim;
  late Animation<double> _pulseAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Floating Collectible
                Transform.translate(
                  offset: Offset(0, _bounceAnim.value),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Text('COLLECT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 2),
                      Text(widget.emoji, style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Truck Image with Event Pulse
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.isEvent)
                      Container(
                        width: 80 * _pulseAnim.value,
                        height: 80 * _pulseAnim.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withOpacity(0.3 * (1.3 - _pulseAnim.value)),
                        ),
                      ),
                    Image.asset(
                      widget.assetPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.isEvent ? AppTheme.primary : Colors.white30, width: 1),
                  ),
                  child: Text(widget.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

