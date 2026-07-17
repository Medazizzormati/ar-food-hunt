import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTop = _scrollController.offset > 200;
      });
    });
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
          
          // Map Pins (Mock)
          const Positioned(
            top: 200, left: 80,
            child: AnimatedFoodTruckMarker(
              assetPath: 'assets/images/burger_truck.png',
              emoji: '🍔',
              name: 'Burger Bliss',
              isEvent: true,
            ),
          ),
          const Positioned(
            top: 150, left: 240,
            child: AnimatedFoodTruckMarker(
              assetPath: 'assets/images/pizza_truck.png',
              emoji: '🍕',
              name: 'Pizza Planet',
              isEvent: false,
            ),
          ),
          const Positioned(
            top: 350, left: 180,
            child: AnimatedFoodTruckMarker(
              assetPath: 'assets/images/ice_cream_truck.png',
              emoji: '🍦',
              name: 'Ice Cream Van',
              isEvent: false,
            ),
          ),
          const Positioned(
            top: 380, left: 30,
            child: AnimatedFoodTruckMarker(
              assetPath: 'assets/images/taco_truck.png',
              emoji: '🌮',
              name: 'Taco Trek',
              isEvent: true,
            ),
          ),
          
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
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildListTruck(context, 'Burger Bliss', '50m', '🍔', 'Active Event', Colors.orange),
                          _buildListTruck(context, 'Pizza Planet', '120m', '🍕', 'Open', Colors.green),
                          _buildListTruck(context, 'Ice Cream Van', '250m', '🍦', 'Special Drops', Colors.teal),
                          _buildListTruck(context, 'Taco Trek', '180m', '🌮', 'Open', Colors.purple),
                          _buildListTruck(context, 'Donut Delight', '320m', '🍩', 'Special Drops', Colors.pink),
                          _buildListTruck(context, 'BBQ Brothers', '450m', '🍖', 'Active Event', Colors.red),
                          _buildListTruck(context, 'Smoothie Station', '280m', '🥤', 'Open', Colors.blue),
                        ],
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

