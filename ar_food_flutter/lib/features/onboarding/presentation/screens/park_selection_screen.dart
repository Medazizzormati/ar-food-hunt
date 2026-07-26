import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/api_service.dart';
import 'dart:convert';
import '../main.dart';

class ParkSelectionScreen extends StatefulWidget {
  const ParkSelectionScreen({super.key});

  @override
  State<ParkSelectionScreen> createState() => _ParkSelectionScreenState();
}

class _ParkSelectionScreenState extends State<ParkSelectionScreen> {
  List<dynamic> parks = [];
  bool isLoading = true;
  String? selectedParkId;

  @override
  void initState() {
    super.initState();
    _loadParks();
  }

  Future<void> _loadParks() async {
    try {
      final response = await ApiService.getParks();
      if (response.statusCode == 200) {
        setState(() {
          parks = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectPark(String parkId, String parkName) async {
    // Save selected park to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_park_id', parkId);
    await prefs.setString('selected_park_name', parkName);
    
    // Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBgMain : AppTheme.lightBgMain,
      appBar: AppBar(
        title: const Text('Select Park'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : parks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city_outlined,
                        size: 64,
                        color: isDark 
                            ? AppTheme.darkTextMuted 
                            : AppTheme.lightTextMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No parks available',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark 
                              ? AppTheme.darkTextPrimary 
                              : AppTheme.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: parks.length,
                  itemBuilder: (context, index) {
                    final park = parks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => _selectPark(
                          park['id'].toString(),
                          park['name'],
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
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppTheme.primary.withOpacity(0.1),
                                    ),
                                    child: park['imageUrl'] != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              park['imageUrl'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.location_city,
                                                  color: AppTheme.primary,
                                                );
                                              },
                                            ),
                                          )
                                        : Icon(
                                            Icons.location_city,
                                            color: AppTheme.primary,
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          park['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDark 
                                                ? AppTheme.darkTextPrimary 
                                                : AppTheme.lightTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          park['location'] ?? 'Unknown location',
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
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: isDark 
                                        ? AppTheme.darkTextMuted 
                                        : AppTheme.lightTextMuted,
                                  ),
                                ],
                              ),
                              if (park['description'] != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  park['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark 
                                        ? AppTheme.darkTextMuted 
                                        : AppTheme.lightTextMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
