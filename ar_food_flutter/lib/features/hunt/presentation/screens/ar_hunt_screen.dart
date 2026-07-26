import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planar.dart';
import 'package:ar_flutter_plugin/datatypes/node_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import '../../../core/theme/app_theme.dart';

class ARHuntScreen extends StatefulWidget {
  const ARHuntScreen({super.key});

  @override
  State<ARHuntScreen> createState() => _ARHuntScreenState();
}

class _ARHuntScreenState extends State<ARHuntScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  List<ARAnchor> anchors = [];

  @override
  void initState() {
    super.initState();
    initializeAR();
  }

  Future<void> initializeAR() async {
    arSessionManager = ARSessionManager();
    await arSessionManager!.onInit();
    
    arObjectManager = ARObjectManager();
    await arObjectManager!.onInit();
    
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      customPlaneTexturePath: null,
      showWorldOrigin: false,
    );
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  void _addCollectibleAnchor() {
    // This would be called when a collectible is detected
    // For now, it's a placeholder for AR functionality
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBgMain : AppTheme.lightBgMain,
      appBar: AppBar(
        title: const Text('AR Hunt'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: arSessionManager == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // AR View
                ARView(
                  onARViewCreated: onARViewCreated,
                  type: ARType.DEFAULT,
                ),
                
                // UI Overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? AppTheme.darkBgCard.withOpacity(0.8)
                          : AppTheme.lightBgCard.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'AR Hunt Mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark 
                                ? AppTheme.darkTextPrimary 
                                : AppTheme.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Point your camera at food trucks to discover collectibles',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark 
                                ? AppTheme.darkTextMuted 
                                : AppTheme.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager) {
    this.arSessionManager = arSessionManager;
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      customPlaneTexturePath: null,
      showWorldOrigin: false,
    );
  }
}
