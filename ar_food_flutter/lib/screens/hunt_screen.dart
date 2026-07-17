import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HuntScreen extends StatefulWidget {
  const HuntScreen({super.key});

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Parking lot with trucks)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1565123409695-3756158ac242?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // UI Elements Overlay
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Top Segmented Control (Map View / AR View)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSegment('Map View', false, isDark),
                        _buildSegment('AR View', true, isDark),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Floating Collectibles
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20, left: 60,
                        child: _buildFloatingItem('🍔', 'COLLECT', Colors.orange),
                      ),
                      Positioned(
                        top: 50, right: 60,
                        child: _buildFloatingItem('🍦', 'COLLECT', Colors.orange),
                      ),
                      Positioned(
                        bottom: 40, left: 100,
                        child: _buildFloatingItem('🍦', 'COLLECT', Colors.orange),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Capture Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.white, 
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Scanner Reticle on the Taco Truck
          Positioned(
            bottom: 250,
            right: 40,
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                children: [
                  // Corner brackets
                  Positioned(top: 0, left: 0, child: _buildCorner()),
                  Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: _buildCorner())),
                  Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: _buildCorner())),
                  Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: _buildCorner())),
                  
                  // Central floating taco
                  const Center(child: Text('🌮', style: TextStyle(fontSize: 60))),
                  
                  // Scanning Laser
                  AnimatedBuilder(
                    animation: _scannerController,
                    builder: (context, child) {
                      return Positioned(
                        top: 10 + (_scannerController.value * 120),
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            boxShadow: [
                              BoxShadow(color: Colors.cyanAccent.withOpacity(0.8), blurRadius: 6),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(String title, bool isSelected, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFloatingItem(String emoji, String tag, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Text(
            tag, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white)
          ),
        ),
        // Downward Pointer Arrow
        CustomPaint(
          size: const Size(12, 8),
          painter: TrianglePainter(color: color.withOpacity(0.8)),
        ),
        const SizedBox(height: 2),
        // Item Emoji
        Text(
          emoji, 
          style: const TextStyle(
            fontSize: 48, 
            shadows: [Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))]
          )
        ),
      ],
    );
  }

  Widget _buildCorner() {
    return Container(
      width: 25, height: 25,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    var borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
      
    var borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(size.width / 2, size.height);
    borderPath.lineTo(size.width, 0);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
